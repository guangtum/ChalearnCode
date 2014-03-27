function train_model_segmentdata(config)
% this script traims a model to perform the gesture segmentation from a
% sample
% we will get two models (option 1 and option 2) for each case.
for fi=1:length(config.seg.featypes),
% step 1: load the training data and set up the saving path of the training
% models
   switch config.overallmodel,
       case 'Train' % we train the model using the training dataset 

           traindatapath = config.seg.mattraindata; % get the path of the training data
           matfilepath = print_matsegname(fi,config);   % get the name of the saving file
           fulltraindatapath = fullfile(traindatapath,matfilepath);   % 
           if exist(config.seg.inittrainedpath,'dir')~=7,
              mkdir(config.seg.inittrainedpath);
           end
           % create the path to save the model
           modelsavepathname = fullfile(config.seg.inittrainedpath,['Train_Segmentationmodel_', matfilepath, '.mat']);
           if exist(modelsavepathname,'file')~=2
               train_singlesample_segsvm(fulltraindatapath,modelsavepathname,fi,config);
           end
           
       otherwise % we train the model using the validation dataset (case 'TrainVali' && 'TrainValiTest'), 
           
           % get the training data path, smh features
           matfilepath = print_matsegname(fi,config);   
           validatapath = config.seg.matvalidata;
           fullvalidatapath = fullfile(validatapath,matfilepath);   % 
           if exist(config.seg.inittrainedpath,'dir')~=7,
              mkdir(config.seg.inittrainedpath);
           end
           % create the path to save the model
           modelsavepathname = fullfile(config.seg.inittrainedpath,['Vali_Segmentationmodel_', matfilepath, '.mat']);
           train_singlesample_segsvm(fullvalidatapath,modelsavepathname,config);
   end

end
end
