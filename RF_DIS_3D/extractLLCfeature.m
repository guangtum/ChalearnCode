function extractLLCfeature(accessisafile,outputllcfile, mydict,config)
% step 1: convert ISA features to LLC features
% step 2: max pooling llc features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ISA featrues --> LLC features
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% config llc feature parameters
llcinfo  = config.rfdis3d.llc;

% load isa features and informations
% Xgray_features:n*dim (e.g. 104998*200)
load(accessisafile,'Xgray_features', 'xposv', 'yposv','t_sp','n_sp');

% how many isa features for this gesture
tot_num = t_sp*n_sp;

% compute llc features
% mydict: num*dim (e.g. 1024*200)
llc_features = LLC_coding_appr(mydict,Xgray_features,llcinfo.knn);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% max pooling isa features from different time stamps to a center 'time' 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% split the gesture into a predefined number of intervals(e.g. 6 or 8 or 10 or 12)
timewindows=linspace(1,t_sp,llcinfo.tdim + 1);

positionfeat=[];
% assign each isa feature a label
for i=1:n_sp:tot_num
    positionfeat(i:i+n_sp-1)=1:n_sp;
end
assert(positionfeat(tot_num) == n_sp);
assert(positionfeat(tot_num-n_sp+1)== 1);

% index cell 
for i=1:n_sp
    pos_index(i)=i;
end

% slip the isa feature for each time windows
for i=1:llcinfo.tdim
    st_time = floor(timewindows(i));
    ed_time = ceil(timewindows(i+1));
    st_index = (st_time-1)*n_sp+1;
    ed_index = ed_time*n_sp;
    assert((ed_index-st_index+1) == ((ed_time-st_time+1)*n_sp));
    llc_window_data(i).data = llc_features(st_index:ed_index,:);
    llc_window_data(i).posi = positionfeat(st_index:ed_index);
end

% compute the llc feature (max pooling)
for i=1:llcinfo.tdim
    overallindex = cell(n_sp,1);
    for j=1:n_sp
        overallindex{j}=find(llc_window_data(i).posi==j);
    end
    llcfeaturedata{i}(pos_index,:)=cell2mat(cellfun(@(x) max(llc_window_data(i).data(x,:), [], 1), overallindex(pos_index),'UniformOutput', false));
    gestureinfo{i}.x = xposv; gestureinfo{i}.y = yposv; gestureinfo{i}.np = n_sp;
end

save(outputllcfile,'llcfeaturedata','gestureinfo');
end