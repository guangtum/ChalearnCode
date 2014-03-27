function create_mat_segmentdata(config)
% this script converts the video data(gray/depth/skeleton/label) of
% training/validating/testing to mat files

for fi=1:length(config.seg.featypes),
% step 1: load the training data and set up the saving path of the training
% models
   switch config.overallmodel,
       case 'Train' % get the training dataset for training the segmentation model
          inputdatapath = config.dt.mattraindata;  % get the path of the .mat training data
          segsavepath = config.seg.mattraindata; % the saving path for segmentation data
          matfilepath = print_matsegname(fi,config);   % get the name of the saving file
          savefilepath = fullfile(segsavepath,matfilepath);   % get the full path of the saving file
          if exist(savefilepath,'dir')~=7,
              mkdir(savefilepath);
          end
          
          % '4train' need the labels of the samples,
          % '4annot' does not need the label
          % '4both'  =  '4train' + '4annot'
          switch config.seg.featypes{fi}
              case 'smh'
                  read_mhifeat4trainannot(inputdatapath,savefilepath,config,'4both')
              case 'rlh'
                  read_rlhfeat4trainannot(inputdatapath,savefilepath,config,'4both')
          end 
          %read_mhifeat4trainannot(inputdatapath,savefilepath,config,'annot')
      case 'TrainVali' 
          inputdatapath = config.dt.matvalidata;  % get the path of the .mat training data  
          segsavepath = config.seg.matvalidata; % the saving path for segmentation data
          matfilepath = print_matsegname(fi,config);   % get the name of the saving file
          savefilepath = fullfile(segsavepath,matfilepath);   % get the full path of the saving file
          if exist(savefilepath,'dir')~=7,
              mkdir(savefilepath);
          end
          
          % '4train' need the labels of the samples,
          % '4annot' does not need the label
          % '4both'  =  '4train' + '4annot'
          switch config.seg.featypes{fi}
              case 'smh'
                  read_mhifeat4trainannot(inputdatapath,savefilepath,config,'4both')
              case 'rlh'
                  read_rlhfeat4trainannot(inputdatapath,savefilepath,config,'4both')
          end           
          
      case 'TrainValiTest'
          inputdatapath = config.dt.mattestdata;  % get the path of the .mat training data  
          segsavepath = config.seg.mattestdata; % the saving path for segmentation data
          matfilepath = print_matsegname(fi,config);   % get the name of the saving file
          savefilepath = fullfile(segsavepath,matfilepath);   % get the full path of the saving file
          if exist(savefilepath,'dir')~=7,
              mkdir(savefilepath);
          end
          
          % '4train' need the labels of the samples,
          % '4annot' does not need the label
          % '4both'  =  '4train' + '4annot'
          
          switch config.seg.featypes{fi}
              case 'smh'
                  read_mhifeat4trainannot(inputdatapath,savefilepath,config,'4annot')
              case 'rlh'
                  read_rlhfeat4trainannot(inputdatapath,savefilepath,config,'4annot')
          end
   end
end
end
  