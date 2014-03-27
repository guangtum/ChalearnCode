%clear all; close all; clc;

createConfiguration;

% unzip all the samples
%create_unzip_inputdata(config, 1, 0, 0);

%% generate input .mat file (including skeleton and label information)
%create_mat_inputdata_g(config, 1, 0, 0);

%% generate input .mat file for training the gesture segmentations
%create_mat_segmentdata(config);

%% train the gesture segmentation models
%train_model_segmentdata(config);

%% test the gesture segmentation models
%test_model_segmentdata(config);

%% Annotation the samples based the segementation models.
annot_model_segmentdata(config);

% refine the trained model of gesture segmentation tasks (refine the start and end position)
% refine_model_segmentdata(config);

% when training ISA  consider drop the depth patch that have many zero
% depth points 

%% train unsupervised feature
% train_unsupervised_feature(config)