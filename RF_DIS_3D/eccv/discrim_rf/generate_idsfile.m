function generate_idsfile(trainingpath)

[fid,msg] = fopen(trainingpath); % trainingpath = 'randomforest/llc_extraction/VOC2011ori/TrainVal/VOCdevkit/VOC2011/ImageSets/Action/trainval.txt'; % the list of training data(background)
tline = fgetl(fid);
str = 'randomstring';
count = 0;
result = [];
hi ='randomforest/images/JPEGImages';
name = 'VOC Action Classification';

while ischar(tline)


count = count + 1;

tline = fgetl(fid);

end   % only use to get the count number



ids_bg = cell(count,1);
fclose(fid);
count = 0;
[fid,msg] = fopen(trainingpath);
tline = fgetl(fid);
savefile = 'ids_bg.mat';
while ischar(tline)

count = count + 1;
c = tline;

%disp(c);
ids_bg{count,1}=c; % save the id (name) of the images

tline = fgetl(fid);

end

fprintf('number of training/val data is %d\n', count);


fclose(fid);


save(savefile, 'ids_bg');
end