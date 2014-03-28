%% config Training/Validating/Testing data;
% hip center 1; Spine 2; ShoulderCenter 3; head 4; ShoulderLeft 5;
% ElbowLeft 6; WristLeft 7; HandLeft 8; ShoulderRight 9; ElbowRight 10;
% WristRight 11; HandRight 12; HipLeft 13; KneeLeft 14; AnkleLeft 15;
% FootLeft 16; HipRight 17; KneeRight 18; AnkleRight 19; FootRight 20;

dbstop error;
currpath=fileparts(mfilename('fullpath'));
f1path = fathermenu(currpath,1);
f2path = fathermenu(currpath,2);
config.chalearn2014path = f2path;           % will use code to get the path

% Enable matlabpool? If so, enter how many cores.
config.parallel.enable = 1;
%config.parallel.cores = 2 ;

config.overallmodel='Train'; % 'TrainVali'; % 'TrainValiTest'
% whether train/vali/test data have the labels
config.train.flag   = [1 1]; % data ready, label ready
config.vali.flag    = [0 0]; % data ready, label ready
config.test.flag    = [0 0];

config.gray.flag = 1; % grayscaledata is ready
config.depth.flag = 0; % depth data is not ready

config.dropsample= [417];

config.dt.orgtraindata = fullfile(config.chalearn2014path,'ChalearnData','Traindata');     % include the original training data from Chalearn2014 [Train1, Train2, Train3, Train4, Train5]
config.dt.orgvalidata = fullfile(config.chalearn2014path,'ChalearnData','Validata');    % include the original validation data from chalearn2014 [Vali1, Vali2]
config.dt.orgtestdata = fullfile(config.chalearn2014path,'ChalearnData','Testdata');    % include the original testing data from chalearn2014 [Vali1, Vali2]
config.dt.sketraindata = fullfile(config.chalearn2014path,'ChalearnData','skeTraindata');
config.dt.mattraindata = fullfile(config.chalearn2014path,'ChalearnData','matTraindata');  % output the mat. format files for training the model
config.dt.matvalidata = fullfile(config.chalearn2014path,'ChalearnData','matValidata');  % output the mat. format files for validating the model
config.dt.mattestdata = fullfile(config.chalearn2014path,'ChalearnData','matTestdata');  % output the mat. format files for validating the model
config.dt.datasetname = 'Chalearn2014Track3'; % name of dataset

%% config gesture segmentation model
config.seg.featypes = {'smh','rlh'};
config.seg.mattraindata = fullfile(config.chalearn2014path,'ChalearnData','segTraindata');
config.seg.matvalidata = fullfile(config.chalearn2014path,'ChalearnData','segValidata');
config.seg.mattestdata = fullfile(config.chalearn2014path,'ChalearnData','segTestdata');
config.seg.inittrainedpath = fullfile(config.chalearn2014path,'ChalearnModel','TrainedSeginit');
config.seg.refitrainedpath = fullfile(config.chalearn2014path,'ChalearnModel','TrainedSegrefi');


%% if we do not know the label of the validation data and test data,
%% we will split the training data into five parts: e.g. 0001-4000 as training data;
%%                                                       4000-5000 as testing  data;
%% Note that we fusion all the samples. 

switch config.overallmodel,
    case 'Train'
        config.seg.train.pool={'segTraindata'}; % 
        config.seg.test.pool={'segTraindata'}; %  
        config.seg.train.fold = 5;
    case 'TrainVali'
        config.seg.train.pool={'segTraindata'}; % 
        config.seg.test.pool={'segValidata'}; % 
        config.seg.train.fold = 5;
    case 'TrainValiTest'
        config.seg.train.pool={'segTraindata','segValidata'}; % 
        config.seg.vali.pool={'segTestdata'}; % 
end

%% config grid search of best model parameters
config.seg.gs.scaledw=-1;
config.seg.gs.scaleup=+1;
config.seg.gs.stepsize = 1;
config.seg.gs.log2cList = -1:config.seg.gs.stepsize:10;
config.seg.gs.log2gList = -10:config.seg.gs.stepsize:1;

config.seg.gs.kernel_type = 2; %radial basis function
config.seg.gs.k_fold = 2; 



%% config SkeletonMotionHistory model (for segmentation)
config.seg.smh.classes = [1,2,3,4]; % consider 4 classes
%config.seg.smh.label = {'no', 'start', 'end', 'center'}; % consider 3 classes
config.seg.smh.fspace = 6; %-6 -5 -4 -3 -2 -1 currentframe +1 +2 +3 +4 +5 +6
config.seg.smh.fgap = 1; % if frame k is the start/end of the gesture, [k-1,k+1] are also the start/end of the gestures.
config.seg.smh.alin = 1; % alingment the skeleton to have the same hip center.
config.seg.smh.featypes = ['X','Y','Z','Rx','Ry','Rz'];
config.seg.smh.pooling = ['Max','Avg','Mit','Ait']; % 'avg','min', and avg and max of them
% select a subset of joints: joints above the hip center
config.seg.smh.seljoints = [1,2,3,4,5,6,7,8,9,10,11,12];

%% config RightLeftHand model (for segmentation)
config.seg.rlh.classes = [1,2,3,4]; % consider 4 classes
%config.seg.smh.label = {'no', 'start', 'end', 'center'}; % consider 3 classes
config.seg.rlh.fspace = 6; %-6 -5 -4 -3 -2 -1 currentframe +1 +2 +3 +4 +5 +6
config.seg.rlh.fgap = 1; % if frame k is the start/end of the gesture, [k-1,k+1] are also the start/end of the gestures.
config.seg.rlh.alin = 1; % alingment the skeleton to have the same hip center.
config.seg.rlh.featypes = ['X','Y','Z','Rx','Ry','Rz'];
config.seg.rlh.pooling = ['Max','Avg','Mit','Ait']; % 'avg','min', and avg and max of them
% select a subset of joints: joints above the hip center
config.seg.rlh.seljoints = [8,12];



%% config ISA model (for spatio-feature learning)
%% if we do not know the label of the validation data and test data,
%% we will split the training data into two parts: e.g. sample0001.zip ~ sample0400.zip as training data;
%%                                                      sample0401.zip ~ sample0490.zip as testing  data;

switch config.overallmodel,
    case 'Train'
        config.isa.train.pool   ={'Traindata'};
        config.isa.test.pool    ={'Traindata'};
        config.isa.train.fold = 5; % 5-fold cross validation
    case 'TrainVali'
        config.isa.train.pool   ={'Traindata','Validata'};
        config.isa.test.pool    ={'Testdata'};
    case 'TrainValiTest'
        config.isa.train.pool   ={'Traindata','Validata'};
        config.isa.test.pool    ={'Testdata'};
end

config.isa.numlayers = 2; % the number of the layers of ISA network
config.isa.catlayers = 1; % whether to concatate several layers

% option: use GPU with Jacket 
config.isa.gpu = 0;

config.isa.featypes = {'Gray','Depth','Clora','Clorb'};
config.isa.trainedfiltpath = fullfile(config.chalearn2014path,'ChalearnModel','TrainedISA','TrainedFilt');

config.isa.mattraindata = fullfile(config.chalearn2014path,'ChalearnData','isaTraindata');
config.isa.matvalidata = fullfile(config.chalearn2014path,'ChalearnData','isaValidata');


%config.isa.feadepth = 1;
%config.isa.feaclora = 0;
%config.isa.feaclorb = 0;

config.isa.l1.imagesize = 16;
config.isa.l1.tempesize = 8;

% convolutional strides
config.isa.l1.imagestride = 4;
config.isa.l1.tempestride = 2;
config.isa.l1.pcadim      = 300;
config.isa.l1.groupsize   = 1; 

config.isa.l2.imagesize   = 20;
config.isa.l2.tempesize   = 10;
config.isa.l2.pcadim      = 200; 
config.isa.l2.groupsize   = 2; 

% dense sample strides
config.isa.ds.imagestride = floor(config.isa.l2.imagesize/2);
config.isa.ds.tempestride = 2;

config.isa.samplespace = 10;

config.isa.samplesplit = 1; % Because we have a large training set, we want to downsample the samples to train the ISA features
                            % 1 is normal, 2 splits into two parts, ... 
config.isa.unsupsamplespergesture = [200; 200; 200];
                            % assume we have 500 samples, each sample has
                            % 15 gestures, finally we have 500*15*200=
                            % 1500000 blocks. It is impossible to traing a
                            % model based on such large blocks.
                            
                            


% configmodel;

% controlling variable
config.includeFlippedVideo = 1;
config.usealljointdata = 1;
config.searchISAparam = 1;
config.usesmallsizedata =1;
config.retrainmodel = 0; 

% Grayscale ISA
config.ISA.gimageSize = 10;
config.ISA.gtempeSize = 8;
% Depth ISA
config.ISA.dimageSize = 10;
config.ISA.dtempeSize = 8;


% configure random forest && discriminative 3d model

% how many classes of gesture to be trained?
config.rfdis3d.class.num =20;

% which kind of data is used for training and testing 
config.rfdis3d.data.na='m_toy'; % m_tr, m_tr_vl, m_tr_vl_te

% specify the range of the training and testing data
switch config.rfdis3d.data.na,
    case 'm_toy'
        % training data
        config.rfdis3d.data.tr.st=1;
        config.rfdis3d.data.tr.ed=50;
        % testing data
        config.rfdis3d.data.te.st=51;
        config.rfdis3d.data.te.ed=100;
        config.rfdis3d.data.te.lb=1; % will the testing data provide the labels of the gestures?
    case 'm_tr'
        % some error data
        % training data
        config.rfdis3d.data.tr.st=1;
        config.rfdis3d.data.tr.ed=350;
        % testing data
        config.rfdis3d.data.te.st=351;
        config.rfdis3d.data.te.ed=470;
        config.rfdis3d.data.te.lb=1; % will the testing data provide the labels of the gestures?    
    case 'm_tr_vl'
        % some error data (need to consider this situation)
        % training data
        config.rfdis3d.data.tr.st=1;
        config.rfdis3d.data.tr.ed=470;
        % testing data
        config.rfdis3d.data.te.st=471;
        config.rfdis3d.data.te.ed=580; % ????
        config.rfdis3d.data.te.lb=1; % will the testing data provide the labels of the gestures?    
    case 'm_tr_vl_te'
        config.rfdis3d.data.te.lb=1; % will the testing data provide the labels of the gestures?    

        
end

% configure paths for different data/feature/model

% where to save the '.txt' files that include the sample name, the gesture
% strart point, end point, label, each gesture information for each row
% -->generate_traintest_index_label.m
config.rfdis3d.path.savedataindex=fullfile(config.chalearn2014path,'ChalearnFeature','isaIndexdata');

% where to save the ISA features for training and testing data
% we save all the samples together(under the same directory)
% -->
config.rfdis3d.path.saveisafeatures=fullfile(config.chalearn2014path,'ChalearnFeature','isaFeature');

% where to save the dictionary of ISA features from the training data
% -->
config.rfdis3d.path.saveisadictionaries=fullfile(config.chalearn2014path,'ChalearnFeature','isaDictionary');

% where to save the LLC features for training and testing data
% we save all the samples together(under the same directory)
config.rfdis3d.path.savellcfeatures=fullfile(config.chalearn2014path,'ChalearnFeature','llcFeature');

% where to save the binary features for the training algorithm 
config.rfdis3d.path.savebinfeatures=fullfile(config.chalearn2014path,'ChalearnFeature','binFeature');

config.rfdis3d.path.savetreemodels=fullfile(config.chalearn2014path,'ChalearnModel','dt3DTrees');


% fusion stragety
% 1, we learn the model using single feature, can combine the results of
% differetn features together. (earlyfusion)
% 2, we learn the model using combined feature(e.g. combine llc features)
% (latefusion)

config.rfdis3d.fusion = '2_3';
config.rfdis3d.feafusion = 1;

config.rfdis3d.dict.size   = 1024;
config.rfdis3d.dict.percent = 2000; %number of kmeans samples *Per Centroid*

config.rfdis3d.dict.desp   = 4e6;
config.rfdis3d.dict.kminit = 1; % 3 %number of random kmeans initializations
config.rfdis3d.dict.seed   = 10; % random seed for kmeans

config.rfdis3d.llc.knn = 5;
config.rfdis3d.llc.tdim = 10;

params.num_centroids = 3000; %for kmeans feature aggregation: recommend 1e4 centroids when using linear kernel, 3000 centroids when using chi-squared kernel
params.num_km_init = 1; %number of random kmeans initializations
params.num_km_samples = 1000; %number of kmeans samples *Per Centroid*
params.seed = 10; %random seed for kmeans

% Grayscale Dictionary learning
config.dictionary.gsize = 1024;
config.dictionary.gnumImages = 4000; % Number of images to sample
config.dictionary.gnumDescriptors = 4e6; % Maximum number of descriptors to 
                                        % use for dictionary learning
% Depth Dictionary learning
config.dictionary.dsize = 1024;
config.dictionary.dnumImages = 4000; % Number of images to sample
config.dictionary.dnumDescriptors = 4e6; % Maximum number of descriptors to 
                                        % use for dictionary learning
                                        
% Grayscale+Depth Dictionary learning (for early fusion)
config.dictionary.gdsize = 1024;
config.dictionary.gdnumImages = 4000; % Number of images to sample
config.dictionary.gdnumDescriptors = 4e6; % Maximum number of descriptors to 
                                    % use for dictionary learning
                                    
% LLC coding
config.LLC.knn = 5;

% Mat file variables
config.matFiles.gridSpacing = 4;
config.matFiles.patchSize = 8;

% Enable matlabpool? If so, enter how many cores.


% Auxillary variables
config.flipSuffix = {'', '_f'};
config.imageSets = {'tr', 'te'};

trainingpath = 'randomforest/llc_extraction/VOC2011ori/TrainVal/VOCdevkit/VOC2011/ImageSets/Action/trainval.txt'; % the list of training data(background)
savefile = 'VOCActionDataset.mat'; % file name of the dataset
hi = 'randomforest/images/JPEGImages'; % path where training and test images exist
name = 'VOC Action Classification'; % name of dataset
testpath = 'randomforest/llc_extraction/VOC2011ori/Test/VOCdevkit/VOC2011/ImageSets/Action/test.txt';% the list of test data(background)

config.outputFolder = 'savefeature_bg';% the output path to save the feature extracton result for background feature




%foreground 

% Folder where SIFT descriptors/LLC histograms/final files are output
config_fg.outputFolder = 'savefeature_fg'; % the output path to save the feature extracton result for foreground feature



% generate input .mat file
trainingpath_fg = 'randomforest/llc_extraction/train_fg.txt';% the list of training data(foreground)
savefile_fg = 'VOCActionDatasetfg.mat';% file name of the dataset
hi_fg ='randomforest/llc_extraction/dataset_fg';% path where training and test images exist
name_fg ='VOC Action Classification fg';% name of dataset 
testpath_fg ='randomforest/llc_extraction/test_fg.txt';% the list of test data(foreground)


%foreground parameter configuration

config_fg.includeFlippedImages = 1;

% Grayscale SIFT
config_fg.SIFT.imageSize = 300;
config_fg.SIFT.gridSpacing = 4;
config_fg.SIFT.patchSize = [8 12 16 24 30];
config_fg.SIFT.sigmaEdge = 0.8;

% Dictionary learning
config_fg.dictionary.size = 1024;
config_fg.dictionary.numImages = 4000; % Number of images to sample
config_fg.dictionary.numDescriptors = 4e6; % Maximum number of descriptors to 
                                        % use for dictionary learning
% LLC coding
config_fg.LLC.knn = 5;

% Mat file variables
config_fg.matFiles.gridSpacing = 4;
config_fg.matFiles.patchSize = 8;   %what does 8 mean?


% Auxillary variables
config_fg.flipSuffix = {'', '_f'};
config_fg.imageSets = {'tr', 'te'};

trainingfilepath = [config.outputFolder '/' name '/tr.mat' ];
trainingfileflippedpath = [config.outputFolder '/' name '/tr_f.mat' ];
trainingfilepath_fg =[config_fg.outputFolder '/' name_fg '/tr.mat' ];
trainingfileflippedpath_fg = [config_fg.outputFolder '/' name_fg '/tr_f.mat' ];
trainingfilegt='randomforest/llc_extraction/VOC2011ori/TrainVal/VOCdevkit/VOC2011/ImageSets/Action/'; % the path where the list of each action training data exists

testfilepath = [config.outputFolder '/' name '/te.mat' ];
testfileflippedpath = [config.outputFolder '/' name '/te_f.mat' ];
testfilepath_fg =[config_fg.outputFolder '/' name_fg '/te.mat' ];
testfileflippedpath_fg = [config_fg.outputFolder '/' name_fg '/te_f.mat' ];
testfilegt='randomforest/llc_extraction/testlabels/Action/'; % the path where the list of each action test data exists

