function [TS, nlbs] = load_challenge_data(fname,params)
%
% load_challenge_data.m -- Script for loading skeleton and RGB-D video 
% data for the multimodal gesture challenge. 
% 
% fname: is the path to the directory that contains the (uncompressed) 
% challenge data 
% 
% params: is a struct of parameters indicating: what joints of the skeleton 
% to use (use_joints); the scale parameter for extracting motion histograms
% 
% The user decides to load the video or not, and to extract motion
% histograms or not. 
%
% Hugo Jair Escalante, June 28
% 
% 
%

%% read mat files
d = dir(fname);
isub = [d(:).isdir]; 
nameFolds = {d(isub).name}';
nameFolds = setdiff(nameFolds,{'.','..'})';

%% Load the skeleton information
njoints=length(params.use_joints);
% counter
cnt=1; 

% variables to store skeleton information
X=[];W=[];P=[];Y=[];        
for i=1:length(nameFolds),
    % load the i-th mat file
    eval(['load ' fname nameFolds{i} '\' nameFolds{i} '_data.mat' ]);
    
    xyz=[];dtg=[];pxy=[];    
    % if we do not have the labels
    if isempty(Video.Labels),       
        nfrs(i)=Video.NumFrames;
        
        for j=1:nfrs(i),
            xyz=[xyz;Video.Frames(j).Skeleton.WorldPosition(params.use_joints,:)];
            dtg=[dtg;Video.Frames(j).Skeleton.WorldRotation(params.use_joints,:)];        
            pxy=[pxy;Video.Frames(j).Skeleton.PixelPosition(params.use_joints,:)];                
        end        
        TS(cnt).name=nameFolds{i};
         TS(cnt).XYZ=[reshape((xyz(:,1)),20,Video.NumFrames);reshape((xyz(:,2)),20,Video.NumFrames);reshape((xyz(:,3)),20,Video.NumFrames)];
         TS(cnt).DTG=[reshape((dtg(:,1)),20,Video.NumFrames);reshape((dtg(:,2)),20,Video.NumFrames);reshape((dtg(:,3)),20,Video.NumFrames)];
         TS(cnt).PXY=[reshape((pxy(:,1)),20,Video.NumFrames);reshape((pxy(:,2)),20,Video.NumFrames);];
         
         %% uncomment this code to extract video and motion histograms
%         % load RGB and Depth video
%         sss=dir([fname nameFolds{i} '\*.mp4']);
%         [M0, fps]=read_movie([fname nameFolds{i} '\' sss(1).name]); 
%         % extract motion histograms
%         [T, p, n]=motion_histograms(M0,params.scale);
% 
%         [K0, fps]=read_movie([fname nameFolds{i} '\' sss(2).name]); 
%         % extract motion histograms
%         [TK, p, n]=motion_histograms(K0,params.scale);
%         
% 
%         TS(cnt).MH=T;        
%         TS(cnt).MH_D=TK;

       
        % saving video is too expensive (in terms of memory)        
%         TS(cnt).M0=M0;
%         TS(cnt).K0=K0;                
%         
        cnt=cnt+1;
         
    % else-if we have the labels
    else
    
    % get skeleton information    
    nfrs(i)=Video.NumFrames;
    nlbs(i)=length(Video.Labels);
    
    for j=1:nfrs(i),
        xyz=[xyz;ones(njoints,1).*j,Video.Frames(j).Skeleton.WorldPosition(params.use_joints,:)];
        dtg=[dtg;Video.Frames(j).Skeleton.WorldRotation(params.use_joints,:)];        
        pxy=[pxy;Video.Frames(j).Skeleton.PixelPosition(params.use_joints,:)];                
    end
    %% uncomment this code to extract video and motion histograms
%     % load RGB and Depth video
%     sss=dir([fname nameFolds{i} '\*.mp4']);
%     [M0, fps]=read_movie([fname nameFolds{i} '\' sss(1).name]); 
%     % extract motion histograms
%     [T, p, n]=motion_histograms(M0,params.scale);
%       
%     [K0, fps]=read_movie([fname nameFolds{i} '\' sss(2).name]); 
%     % extract motion histograms
%     [TK, p, n]=motion_histograms(K0,params.scale);
    
        

    % get skeleton information   
    for j=1:length(Video.Labels),                
       
        % find the boundaries for this gesture
        ofin=Video.Labels(j).Begin:Video.Labels(j).End;

                
        % extract data for frames with a gesture
        [A,B]=ismember(xyz(:,1),ofin);
        idx=find(A);
      
        if j==1,
            starting_frame(cnt)=Video.Labels(j).Begin;
        else
            starting_frame(cnt)=Video.Labels(j).Begin-Video.Labels(j-1).End;
        end            
        
        TS(cnt).labels=Video.Labels(j).Name;
        TS(cnt).id_labels=getGestureID(Video.Labels(j).Name);
        TS(cnt).duration=[Video.Labels(j).Begin,Video.Labels(j).End,Video.Labels(j).End-Video.Labels(j).Begin];
        TS(cnt).XYZ=[reshape((xyz(idx,2)),20,length(ofin));reshape((xyz(idx,3)),20,length(ofin));reshape((xyz(idx,4)),20,length(ofin))];            
        TS(cnt).DTG=[reshape((dtg(idx,1)),20,length(ofin));reshape((dtg(idx,2)),20,length(ofin));reshape((dtg(idx,3)),20,length(ofin));reshape((dtg(idx,4)),20,length(ofin))];
        TS(cnt).PXY=[reshape((pxy(idx,1)),20,length(ofin));reshape((pxy(idx,2)),20,length(ofin));];            
        TS(cnt).sample=i;     
        TS(cnt).name=nameFolds{i};

%% uncomment this code to extract video and motion histograms
%         ofinV=ofin<=size(T,1);
%         TS(cnt).MH=T(ofin(find(ofinV)),:);
%         ofinV=ofin<=size(TK,1);
%         TS(cnt).MH_D=TK(ofin(find(ofinV)),:);        
%        % saving video is too expensive (in terms of memory)        
%         TS(cnt).M0=M0(ofin(find(ofinV)));
%         TS(cnt).K0=K0(ofin(find(ofinV)));
        
        sampleid(cnt)=i;
        cnt=cnt+1;        
    end  
    
    end
end

if ~exist('nlbs','var'),
    nlbs=[];
end

end