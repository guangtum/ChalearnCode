function [mexbinname, mexouttree, timestamps]=creat_input_variable_4mex(config)
% this script output binary files
%% if config.rfdis3d.fusion = '2_3'. 
% we save different binary files for different time windows (default)
% if config.rfdis3d.fusion = '2_2'. 
% we save only one binary files for different time windows; maxpooling(t1,t2,t3...t10)
% if config.rfdis3d.fusion = '2_1'. 
% we save only one binary files for different time windows; t1+t2+t3+...+t10
% if config.rfdis3d.fusion = '1_3'. 
% We fusion data, then train the dictionary. independent 
% if config.rfdis3d.fusion = '1_2'. 
% We fusion data, then train the dictionary. maxpooling 
% if config.rfdis3d.fusion = '1_2'. 
% We fusion data, then train the dictionary. ++++++++++
%%%%%%%%%  200 should be changed in the future.
datainfo  = config.rfdis3d.data;
pathinfo  = config.rfdis3d.path;
llcinfo  = config.rfdis3d.llc;

outputbinpath = pathinfo.savebinfeatures;
outputtreepath = pathinfo.savetreemodels;
exist_make_path(outputtreepath);

for fi=1:1
    % get the start and end position of the training and testing gestures
    if fi==1
        sample_st=datainfo.tr.st;
        sample_ed=datainfo.tr.ed;
        sample_fg='train';
    else
        sample_st=datainfo.te.st;
        sample_ed=datainfo.te.ed;
        sample_fg='test';
    end
    mexbinname=fullfile(outputbinpath,[printbinaryfilename(sample_fg,config) '_twindows']);
    [~,binname,~]=fileparts(mexbinname);
    
    mexouttree=fullfile(outputtreepath,[binname '_' num2str(llcinfo.tdim)]);
    exist_make_path(mexouttree);
    timestamps = llcinfo.tdim;
end
