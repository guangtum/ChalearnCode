function create_matinputdata(config_dt, trainflag, valiflag,testflag)
% this script converts the video data(gray/depth/skeleton/label) of
% training/validating/testing to mat files

% convert training data
if trainflag==1
    fulltrainpath = fullfile(config_dt.chalearn2014path,config_dt.orgtraindata); % get the path of the training data
    sample_zip= dir([fulltrainpath,filesep,'*.zip']); % get all the zip file name
    

    
end
% if training data exist

% makedir if mat_training not existing


% convert validating data
% convert testing data

[fid,msg] = fopen(trainingpath); % training data path

tline = fgetl(fid);
str = 'randomstring';
count = 0;
result = [];

while ischar(tline)

%disp(tline);
count = count + 1;


c = {strcat(tline,'.jpg'), str(1:0)}; % concatenate strings
f = {'filename', 'folder'};
anno_sub = cell2struct(c,f,2);
c_annotation_sub = {anno_sub};
f_annotation_sub = {'annotation'};
annotation = cell2struct(c_annotation_sub,f_annotation_sub,2);


result = [result annotation]; % struct array

tline = fgetl(fid);

end



fprintf('number of training/val data is %d\n', count);
tr = struct(result);


fclose(fid);


[fid,msg] = fopen(testpath);  % test data path

tline = fgetl(fid);
str = 'randomstring';
count = 0;
result = [];
while ischar(tline)

%disp(tline);
count = count + 1;


c = {strcat(tline,'.jpg'), str(1:0)};
f = {'filename', 'folder'};
anno_sub = cell2struct(c,f,2);
c_annotation_sub = {anno_sub};
f_annotation_sub = {'annotation'};
annotation = cell2struct(c_annotation_sub,f_annotation_sub,2);

result = [result annotation];

tline = fgetl(fid);
end

fprintf('number of test data is %d\n', count);
te = struct(result);


fclose(fid);

%hi path where training and test images exist
%name 'VOC Action Classification',  name of dataset

save(savefile, 'hi', 'name', 'tr', 'te');   

end

