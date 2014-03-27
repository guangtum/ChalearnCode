function smhannotations=svm_smhannotations(svmsmhmodel,mmmax,mmmin,config)
% this script converts the video data(gray/depth/skeleton/label) of
% training/validating/testing to mat files

% convert training data
switch config.overallmodel,
  case 'Train'
        %fulldatapath = fullfile(config.dt.chalearn2014path,config.dt.orgtraindata); % get the path of the training data
        %fullsavepath = fullfile(config.dt.chalearn2014path,config.dt.mattraindata);
    fulldatapath = config.dt.mattraindata;  % get the path of the .mat training data
  case 'TrainVali'
  case 'TrainValiTest'
end
sample_mat= dir([fulldatapath,filesep,'*_Mvideo.mat']); % get all the zip file name

for i=1:length(sample_mat), % sampling data from each samples
   if i ==417
      continue;
   end
           % get the information/data from each sample
   i
   samplename = sample_mat(i).name;
   tempsample=fullfile(fulldatapath,samplename);
   load(tempsample, 'modalityData'); 
   % get the data for training the segmentation model
   switch config.seg.featypes{fi}
       case 'smh'
          smhsamplefeature{i}=read_mhisegmentationsample(modalityData,config);
       case 'paircase'
   end
   clear modalityData smhlabeldata; 
end

end

