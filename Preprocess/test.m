currpath=fileparts(mfilename('fullpath'));
f1path = fathermenu(currpath,1);
f2path = fathermenu(currpath,2);
f3path =fullfile (f2path,'ChalearnData','DTraindata');
seqdir=dir([f3path,filesep,'*.zip']);
%sampledata={};
for i=1:1%length(seqdir)
    tempsample=fullfile(f3path,seqdir(i).name);
    [path,sampleID,ext]=fileparts(tempsample);
    sampleDir=fullfile(path,sampleID);

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
    %modalityData=initmodality(modalityData);
    % Get framenumber gesturenumber maxdepth
    modalityData.vinfo = read_datacsv(csv_datapath);
    modalityData.framenum = modalityData.vinfo(1);
    modalityData.depthmax = modalityData.vinfo(3);
    
    % 1.Get the labels and the start and end frame of each gesture, 
    % 2.labels for all frames
    % [modalityData.samplelabel, modalityData.sampleanno] = read_labelcsv(modalityData.framenum,csv_labelpath);  % label = 0 ?
    
    % Get the skele data
    % modalityData.sampleskele = read_skelecsv(modalityData.framenum,csv_skelepath);  % label = 0 ?
     
    cal_depthmotiondiff()
    % Get RGB data (here we use the grayscale of the RGB video data)
    % modalityData.samplegray=read_grayvideo(modalityData,video_rgbpath);
    
    % Get a,b data (here we use the l,a,b of the RGB video data)
    % [modalityData.samplelaba,modalityData.samplelabb]=read_labvideo(modalityData,video_rgbpath);

    % Get Depth data
    % modalityData.sampledepth=read_depthvideo(modalityData,video_depthpath);
    
    % Get Normal data
    % modalityData.sampledepth=read_normalvideo(modalityData,video_depthpath);
    
    % Get User segmentation
    %modalityData.sampleuser=read_uservideo(modalityData,video_userpath);
    
    %removeunzipsample(tempsample);
    %read the python file  # Name:        Chalearn LAP sample
end