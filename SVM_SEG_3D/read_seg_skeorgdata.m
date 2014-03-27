function read_seg_skeorgdata(orgdatapath,saveskedatapath,savevideodatapath,config)

sample_zip= dir([orgdatapath,filesep,'*.zip']); % get all the zip file name
for i=1:length(sample_zip),
    samplename = sample_zip(i).name;
    tempsample=fullfile(orgdatapath,samplename);
    [path,sampleID,~]=fileparts(tempsample);
    sampleDir=fullfile(path,sampleID);
        
    matfilename     = [sampleID '_skelabel.mat'];
    saveskefilepath     = fullfile(saveskedatapath,matfilename); 
    disp(['Create ske label .mat input: ' matfilename ' ' num2str(i) ' of ' num2str(length(sample_zip))]);
    
    % unzip original zip file
    unzipsample(tempsample);
        
            % get the sample files directory
    csv_datapath= fullfile(sampleDir,[sampleID '_data.csv']); 
    csv_labelpath= fullfile(sampleDir,[sampleID '_labels.csv']); 
    csv_skelepath= fullfile(sampleDir,[sampleID '_skeleton.csv']); 
    
    video_rgbpath= fullfile(sampleDir,[sampleID '_color.mp4']); 
    video_depthpath= fullfile(sampleDir,[sampleID '_depth.mp4']); 
    video_userpath= fullfile(sampleDir,[sampleID '_user.mp4']); 
    
    if exist(saveskefilepath,'file')~=2, 
        % read the .csv files
        modalityData =struct();
        
        modalityData.samplename=samplename;
        modalityData.vinfo = read_datacsv(csv_datapath);
        modalityData.framenum = modalityData.vinfo(1);
        modalityData.depthmax = modalityData.vinfo(3);

        %1. Get the skele data
        [modalityData.sampleskele, modalityData.skeregion]= read_skelecsv(modalityData.framenum,csv_skelepath);  % label = 0 ?
        
        % 1.Get the labels and the start and end frame of each gesture, 
        % 2.labels for all frames
        [modalityData.samplelabel, modalityData.sampleanno, modalityData.gesturenum] = read_labelcsv(modalityData,csv_labelpath);  % label = 0 ?
        save(saveskefilepath, 'matfilename', 'modalityData');   
    else
        disp(['Already exist:' matfilename]);
        load(saveskefilepath, 'modalityData'); 
    end
    if config.gray.flag == 1; % grayscaledata is ready, we could get the gesture video data
        read_seg_grayvideo(modalityData,savevideodatapath,video_rgbpath);
    end
    
    if config.depth.flag == 1; % grayscaledata is ready, we could get the gesture video data
       read_rawdepthvideo(modalityData,video_depthpath);
    end

    removeunzipsample(tempsample);          
end

end

