function create_seg_skeorgdata(config)
%% this script converts the video data(gray/depth/skeleton/label) of
% training/validating/ to mat files
% notice that zip files of the training and validating have different path.
% But they have the same .mat paths(saving the .mat validating file to .mat path)

%% define the path of the training data
orgtraindatapath = config.dt.orgtraindata; % get the path of the training data
saveskedatapath = config.dt.sketraindata;  % the path of saving skeleton and labeling data(each zip each .mat)
saveorgdatapath = config.dt.mattraindata;  % the path of saving gesture original data (each gesture each .mat)
exist_make_path(orgtraindatapath,saveskedatapath,saveorgdatapath); % if ~exist path, make it

%% define the path of the validation data
orgvalidatapath = config.dt.orgvalidata; % get the path of the training data
saveskedatapath = config.dt.sketraindata;  %%%%%%% the same path with the training data
saveorgdatapath = config.dt.mattraindata;  %%%%%%% the same path with the training data
exist_make_path(orgvalidatapath,saveskedatapath,saveorgdatapath); % if ~exist path, make it

%% get the data of the training data
read_seg_skeorgdata(orgtraindatapath,saveskedatapath,saveorgdatapath,config);

%% get the data of the validating data
read_seg_skeorgdata(orgvalidatapath,saveskedatapath,saveorgdatapath,config);

end

