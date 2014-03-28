% this script trains the model for the chalearn 2014 challenge of track 3.

% before using this script, you need to provide the gestures data/labels
% step 1: create configuration
% step 2: create index 'txt' files of training and testing data 
% step 3:
% step 4:
% step 5:
% step 6:

%% step 1
createConfiguration;

%% step 2


%% step 2
%int:
%out:
%create_traintest_indexlabel(config);

%% step 3
%int: 
%out:
%extract_traintest_isafeature(config);

%% step 4
%int:
%out:
%create_train_isadistionary(config);

%% step 5
%int:
%out:
%extract_traintest_llcfeature(config);

%% step 6 
%int: .mat file; llc features;
%out: .txt file;
output_binaryFeature_4mex(config);
%%% return: the tree path, the binary path, the number of the time windows

%% step 6
rf_dis_3d_train(binraypath,treepath,timewindows);




% generate input .mat file
generate_matinputfile(trainingpath, savefile, hi, name, testpath);
data = load(savefile);



%Extract Grayscale SIFT descriptors
extractSIFT(data, config);

% Generate dictionary for LLC using randomly sampled training images%%
config.dictionary.data = generateDictionary(data, config);


% Generate LLC histograms for all SIFT descriptors
extractLLC(data, config);

% Compile LLC histograms into a single mat file for use with algorithm
createMatFilesBg(data, config);


clear all;
% foreground feature extraction
createConfiguration;
config = config_fg;

% generate input .mat file
generate_matinputfile_fg(trainingpath_fg, savefile_fg, hi_fg, name_fg, testpath_fg);
data = load(savefile_fg);


%Extract Grayscale SIFT descriptors
extractSIFT(data, config);

% Generate dictionary for LLC using randomly sampled training images
config.dictionary.data = generateDictionary(data, config);


% Generate LLC histograms for all SIFT descriptors
extractLLC(data, config);

% Compile LLC histograms into a single mat file for use with algorithm
createMatFilesFg(data, config);


% generate .txt binary feature file

generate_idsfile(trainingpath);

generate_idsfile_fg(trainingpath_fg);  % trainingpath_fg = 'randomforest/llc_extraction/train_fg.txt';% the list of training data(foreground)

outputBinaryFeature(0, 'train', 'notflipped', trainingfilepath, trainingfileflippedpath, trainingfilepath_fg, trainingfileflippedpath_fg, trainingfilegt);
outputBinaryFeature(0, 'train', 'flipped', trainingfilepath, trainingfileflippedpath, trainingfilepath_fg, trainingfileflippedpath_fg, trainingfilegt);


%train random forest
dttrain();

