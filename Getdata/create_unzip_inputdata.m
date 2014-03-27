function create_unzip_inputdata(config, trainflag, valiflag, testflag)
% this script converts the video data(gray/depth/skeleton/label) of
% training/validating/testing to mat files

% convert training data
for flag=1:3,
    if flag==1 && trainflag==1,
        %fulldatapath = fullfile(config.dt.chalearn2014path,config.dt.orgtraindata); % get the path of the training data
        %fullsavepath = fullfile(config.dt.chalearn2014path,config.dt.mattraindata);
        fulldatapath = config.dt.orgtraindata; % get the path of the training data
        fullsavepath = config.dt.mattraindata;
    elseif flag==2 && valiflag==1,
        fulldatapath = fullfile(config.dt.chalearn2014path,config.dt.orgvalidata); % get the path of the training data
        fullsavepath = fullfile(config.dt.chalearn2014path,config.dt.matvalidata);
    elseif flag==3 && testflag==1,
        fulldatapath = fullfile(config.dt.chalearn2014path,config.dt.orgtestdata); % get the path of the training data
        fullsavepath = fullfile(config.dt.chalearn2014path,config.dt.mattestdata);
    else
        continue;
    end
    sample_zip= dir([fulldatapath,filesep,'*.zip']); % get all the zip file name
    for i=1:length(sample_zip),
        samplename = sample_zip(i).name;
        tempsample=fullfile(fulldatapath,samplename);
        [path,sampleID,ext]=fileparts(tempsample);
        sampleDir=fullfile(path,sampleID);
        
        %save file
        matfilename     = [sampleID '_Mvideo.mat'];
        savefilepath     = fullfile(fullsavepath,matfilename); 
        disp(['Create .mat input: ' matfilename ' ' num2str(i) ' of ' num2str(length(sample_zip))]);
        %if exist(savefilepath,'file')==2,
         %   disp(['Already exist:' matfilename]);
          %  continue;
        %end
        %sampledata=getSampledata(tempsample);
        unzipsample(tempsample);
        
            % get the sample files directory
        csv_datapath= fullfile(sampleDir,[sampleID '_data.csv']); 
        csv_labelpath= fullfile(sampleDir,[sampleID '_labels.csv']); 
        csv_skelepath= fullfile(sampleDir,[sampleID '_skeleton.csv']); 
    
        video_rgbpath= fullfile(sampleDir,[sampleID '_color.mp4']); 
        video_depthpath= fullfile(sampleDir,[sampleID '_depth.mp4']); 
        video_userpath= fullfile(sampleDir,[sampleID '_user.mp4']); 
     
        % read the .csv files
        modalityData =struct();
        
        modalityData.samplename=samplename;
        modalityData.vinfo = read_datacsv(csv_datapath);
        modalityData.framenum = modalityData.vinfo(1);
        modalityData.gesturenum = modalityData.vinfo(2);
        modalityData.depthmax = modalityData.vinfo(3);

        % 1. Get the skele data
        [modalityData.sampleskele, modalityData.skeregion]= read_skelecsv(modalityData.framenum,csv_skelepath);  % label = 0 ?
        
        % 1.Get the labels and the start and end frame of each gesture, 
        % 2.labels for all frames
        [modalityData.samplelabel, modalityData.sampleanno] = read_labelcsv(modalityData,csv_labelpath);  % label = 0 ?
        if exist(savefilepath,'file')==2,
            save(savefilepath, 'matfilename', 'modalityData','-append'); 
            disp('Already exist! Update this .mat file!');
        else
            save(savefilepath, 'matfilename', 'modalityData'); 
        end
        disp('Saving Skeleton and Label information ...... Finished!......1/5');

        
        % Get RGB data (here we use the grayscale of the RGB video data)
        modalityGray=read_grayvideo(modalityData,video_rgbpath);
        disp('......');
        save(savefilepath, 'modalityGray', '-append'); 
        disp('Saving Grayscale information ...... Finished!......2/5');
        clear modalityGray;
        % Get a,b data (here we use the l,a,b of the RGB video data)
        %[modalityClora,modalityClorb]=read_labvideo(modalityData,video_rgbpath);
        %save(savefilepath, 'modalityClora', 'modalityClorb','-append'); 
        %disp('Saving a,b information ...... Finished!......3,4/5');

        % Get Depth data
        modalityDepth=read_depthvideo(modalityData,video_depthpath);
        disp('......');
        save(savefilepath, 'modalityDepth','-append'); 
        disp('Saving Depth information ...... Finished!......5/5');
        clear modalityDepth;
        % Get Normal data
        % modalityNormal=read_normalvideo(modalityData,video_depthpath);
        
        % Get Side and top view data
        % [modalityTop, modalitySide] =read_topsidevideo(modalityData,video_depthpath);

        % Get User segmentation
        %modalityData.sampleuser=read_uservideo(modalityData,video_userpath);
    
        removeunzipsample(tempsample);        
    end  
end

end

