function totalfeature=extractISAfeature(orggesturedatapath, saveisafeaturepath, hand_flag, featclass, network_m, params_m, config)
if 1%config.gray.flag == 1;  % grayscaledata is ready
    network= network_m; % 
    params = params_m; 
    fovea = params.fovea{2};
    if params.num_isa_layers >= 2
        assert(size(network.isa{2}.H,2) == size(network.isa{2}.W,1));
    end
    % load the video data (just a gesture!! not a sample)
    switch featclass,
        case 'Gray'
           load(orggesturedatapath,'Xgray');
        case 'Depth'
           load(orggesturedatapath,'Xdepth');
           Xgray=Xdepth;
           clear Xdepth;
    end
    
    
    % if the gesture is performed by the left hands, converts to the right
    % hands
    if strcmp(hand_flag,'left'), % flip the gesture
        for ti =1:size(Xgray,3),
            Xgray(:,:,ti)=fliplr(Xgray(:,:,ti));
        end
    end
    
    % we should crop some of the pixels (e.g. 305*305*11, we may only need 300*300*10)
    Xgray = crop_video_blk_spte(Xgray, fovea.spatial_size,fovea.temporal_size, params.ds.tempestride);
    [hgt,wid,tfr]=size(Xgray);

    [xposv,yposv,gridx,gridy]=generate_isa_2DGrid(hgt,wid,fovea.spatial_size,params.ds.imagestride);
    % we exteact isa features at different frames(has temporal ....)
    % dense sampling 't_sp' times along the temporal dimension
    xgridv=reshape(gridx,(size(gridx,1))^2,[]);
    ygridv=reshape(gridy,(size(gridy,1))^2,[]);
    
    n_raw=numel(xposv)*fovea.spatial_size*fovea.spatial_size;
    colXgray = zeros(n_raw,tfr);
    for i=1:tfr
        ed=0;
        for j=1:numel(xposv)  %% x --> size 2 --> which column; y ---> size 1 ---> which row
            st=ed+1;
            ed=st+fovea.spatial_size*fovea.spatial_size-1;
            colXgray(st:ed,i)= reshape(Xgray(ygridv(j,1):ygridv(j,1)+fovea.spatial_size-1,xgridv(j,1):xgridv(j,1)+fovea.spatial_size-1,i),fovea.spatial_size*fovea.spatial_size,[]);
        end
    end
    
    % get the final version of the data to compute the isa features.
    % finalXgray: nXm, n means sp*sp*tp means the raw pixels informations,
    % m means how many blocks(cubic patches)
    t_sp=(tfr-fovea.temporal_size)/params.ds.tempestride+1;
    n_sp=numel(xposv);
    finalXgray=[];
    for i=1:t_sp
        gst=(i-1)*params.ds.tempestride+1;
        ged=gst+fovea.temporal_size-1;
        finalXgray=[finalXgray im2col(colXgray(:,gst:ged),[fovea.spatial_size*fovea.spatial_size,fovea.temporal_size], 'distinct')];    
    end
    
    % get the isa features       
    if params.num_isa_layers == 1
        act_l1 = activateISA(finalXgray, network.isa{1}, params.postact.layer1);                                
                
        Xgray_features = act_l1';
        Xgray_mmeasure = sum(abs(act_l1), 1)';
                
    elseif params.num_isa_layers == 2                                                    
            
        [act_l2, act_l1_pca_reduced, l1_motion] = activate2LISA(finalXgray, network.isa{1}, network.isa{2}, size(finalXgray,2), params.postact);  % l1_motion the sum of each block's first layers features
        act = [act_l2; act_l1_pca_reduced];

        % nXm: where n means how many features, m means the dimension of
        % the feature.
        Xgray_features= act';         
        % store motion measure
        Xgray_mmeasure = l1_motion';                                                
    end
    assert(size(Xgray_features,1) == t_sp*n_sp);
    totalfeature=t_sp*n_sp;
    save(saveisafeaturepath,'Xgray_features','Xgray_mmeasure', 'xposv', 'yposv','t_sp','n_sp');
end