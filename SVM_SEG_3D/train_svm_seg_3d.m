%clear all; close all; clc;

createConfiguration;

% unzip all the samples
%create_unzip_inputdata(config, 1, 0, 0);

%% generate input .mat file (including skeleton and label information)
create_seg_skeorgdata(config);