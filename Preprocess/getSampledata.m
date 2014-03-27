function [videoData,labels]=getSampledata(samplePath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get all the information for a given sample.
%
%     videoData: Information structure. Contains the fields:
%        .NumFrames: Number of frames
%        .FrameRate: 20
%        .MaxDepth: Maximum depth value
%        .Labels: Array of gestures information.
%        .RGB: Cell array with all the RGB frames
%        .Depth: Cell array with all the Depth frames
%        .UserSegmentation: Cell array with the segmentation of the user
%                           for each frame
%        .Skeleton: Skeleton structure for each frame
%        .Audio: Structure with the audio samples and frequency.
%     labels: List of gesture identifiers for given sequence
%
%
%     usage:
%         [data,labels]=getSampleData('Sample00001.zip');
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Split the path and the filename
[path,sampleID,ext]=fileparts(samplePath);
    
% Check that the given file is a zip file
if strcmp(ext,'.zip')~=1,
    warning('Expected a ZIP file as input');
end
       
sampleDir=fullfile(path,sampleID);

    
% If it is necessary, unzip the file
try
   files=unzip(samplePath,sampleDir);
   if isempty(files),
        warning(['Empty extracted file: ' samplePath]);
   end
catch
    warning(['Cannot extract file: ' samplePath]);
end
                
    % Get the video information
    videoData=load(fullfile(sampleDir,[sampleID '_data.mat']));
    videoData=videoData.Video;
    videoData.SampleID=sampleID;
    
     % Get the labels
     if nargout>1,
         % Get frame labels
         labels=getLabels(videoData);
         
         % Get list of gestures
         labels=labels(labels~=[0 labels(1:end-1)]);
         
         % Remove the zeros
         labels=labels(labels~=0);
     end
    
    % Get RGB data
    videoData.RGB=getImageData(videoData,fullfile(sampleDir,[sampleID '_color.mp4']));
    
    % Get Depth data
    videoData.Depth=getDepthData(videoData,fullfile(sampleDir,[sampleID '_depth.mp4']));
    
    % Get User segmentation
    videoData.UserSegmentation=getLabeledData(videoData,fullfile(sampleDir,[sampleID '_user.mp4']));
    
    % Get Audio data
    [videoData.Audio.samples,videoData.Audio.fs] = wavread(fullfile(sampleDir,[sampleID '_audio.wav']));
    
    % Get the Skeleton data
    for i = 1:videoData.NumFrames
       videoData.Skeleton(i)=videoData.Frames(i).Skeleton;
    end
    videoData = rmfield(videoData,'Frames');
        
    % If we unziped the file, remove the folder
    if strcmp(src,'zip'),
        recycleStat=recycle('off');
        try
            rmdir(sampleDir,'s');        
        catch err
            warning(['Cannot remove foler: ' sampleDir ' error: ' err.message]);
        end
       
        recycle(recycleStat);
    end
    
end
function frames=getLabeledData(videoData,path)

    % Some Windows systems fails on loading mp4 files. In case of error, use
    % alternative reading mode.
    try
        mode=1;
        videoFile = vision.VideoFileReader(path);
    catch
        mode=2;
        videoFile = VideoReader(path);
    end
    if mode==1,
        for i = 1:videoData.NumFrames
            frames{i}=rgb2gray(step(videoFile));
        end
    elseif mode==2,
        for i = 1:videoData.NumFrames
            frames{i}=rgb2gray(read(videoFile, i));
        end
    end
end
function frames=getImageData(videoData,path)

    % Some Windows systems fails on loading mp4 files. In case of error, use
    % alternative reading mode.
    try
        mode=1;
        videoFile = vision.VideoFileReader(path);
    catch
        mode=2;
        videoFile = VideoReader(path);
    end
    if mode==1,
        for i = 1:videoData.NumFrames
            frames{i}=step(videoFile);
        end
    elseif mode==2,
        for i = 1:videoData.NumFrames
            frames{i}= read(videoFile, i);
        end
    end
end
function frames=getDepthData(videoData,path)

    % Some Windows systems fails on loading mp4 files. In case of error, use
    % alternative reading mode.
    try
        mode=1;
        videoFile = vision.VideoFileReader(path);
    catch
        mode=2;
        videoFile = VideoReader(path);
    end
    if mode==1,
        for i = 1:videoData.NumFrames
            frames{i}=getDepth(step(videoFile),videoData.MaxDepth);
        end
    elseif mode==2,
        for i = 1:videoData.NumFrames
            frames{i}= getDepth(read(videoFile, i),videoData.MaxDepth);
        end
    end
end
function depth = getDepth(frame,maxDepth)
    depth = uint16(round(double(rgb2gray(frame))/255.0*maxDepth));
end
function labels=getLabels(video)
    % Define an initial label for each frame (0-> no gesture)
    labels=zeros(1,video.NumFrames);
    
    % Initialize the stats
    stats=zeros(1,20);
        
    % For each gesture in the sample generate corresponding labels
    for lab=video.Labels,
        error=0;
        % Check the labels 
        if lab.Begin<=0 || lab.End<=0,
            if error==0,
                error=1;
                warning(['Null index errors in sample: (Gesture -> ' lab.Name ')']);
            end
            continue;
        end
        % Check that the index are correct
        if lab.Begin<1 || lab.End<1 || lab.End<=lab.Begin || lab.End>video.NumFrames,
            warning(['Index error in sample:  (Gesture -> ' lab.Name ')']);
            tmp=lab.Begin;
            lab.Begin=lab.End;
            lab.End=tmp;
        end
        % Check that all afected frames are 0
        if sum(labels(lab.Begin:lab.End))~=0,
            warning('There are overlapped gestures in sample.');
        end
        
        % Get the gesture identifier        
        id=getGestureID(lab.Name);
        
        % Add this value
        stats(id)=stats(id)+1;
                
        % Check that the gesture name is correct
        if id<=0,
            warning(['Unrecognized gesture (' lab.Name ')']);
        end
        
        % Set the labels
        labels(lab.Begin:lab.End)=id;  
    end
end