function [ modalityData ] = initmodality(modalityData)
modalityData.vinfo = [];
modalityData.framenum = 0;
    
    % Get the labels and the start and end frame of each gesture
    modalityData.samplelabel = [];  % label = 0 ?
    
    % Get the skele data
    modalityData.sampleskele = [];  % label = 0 ?

    % Get RGB data (here we use the grayscale of the RGB video data)
    modalityData.samplegray= [];
    
    % Get Depth data
%     modalityData.sampledepth=read_depthvideo(modalityData,video_depthpath);
    
    % Get Normal data
    % modalityData.sampledepth=read_normalvideo(modalityData,video_depthpath);
    
    % Get User segmentation
%     modalityData.sampleuser=read_uservideo(modalityData,video_userpath);
    
    % Get Sample Annotations (all frames have the labels)
%     modalityData.sampleuser=read_labelanno(modalityData,video_userpath);


end

