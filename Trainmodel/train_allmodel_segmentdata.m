function train_allmodel_segmentdata(config)
% this script traims a model to perform the gesture segmentation from a
% sample
% we will get two models (option 1 and option 2) for each case.
for fi=1:length(config.seg.featypes),
% step 1: load the training data and set up the saving path of the training
% models
   switch config.overallmodel,
       case 'Train'    % will use 5-fold cross validation on training data to select the best model (it is not related to option 1 and option2) 
                       % option 1: we can train the model on the 100-400
                       % labeled samples, and test on e.g. 400-470 labeld
                       % samples(final-3:first) to get the parameters of
                       % DBSCAN clustering algorithm
                       % option 2: we can train the model on the whole training data, test the model on the unlabeled validation data(online system,final-2:second)

           kfold=config.isa.train.fold; % 5-fold cross validation
           traindatapath = config.seg.mattraindata; % get the path of the training data
           matfilename = print_matsegname(fi,config);   % get the name of the saving file
           fulltraindatapath = fullfile(traindatapath,matfilename);   % 
           load(fulltraindatapath,'smhlabeldata');
           segtrain=smhlabeldata;

           % create the path to save the model
           modelTrsavepathname = fullfile(config.seg.inittrainedpath,['Train_', matfilename]);
           %modelTesavepathname = fullfile(config.seg.inittrainedpath,['initSeg_secondmodel_', matfilename]);

           
       case 'TrainVali' % will use 5-fold cross validation on the sum of the training and validation data to select the best model
                        % option 1: we can train the model on sum of train
                        %           and validation samples, test the model
                        %           on the unlabeled test samples (online system, final-0:final).
                        % option 2: we can train the model on the train
                        %           samples, test the model
                        %           on the labeled validation data (final-1:third)
           kfold=config.isa.train.fold;
           traindatapath = config.seg.mattraindata; % get the path of the training data
           matfilename = print_matsegname(fi,config);   % get the name of the saving file
           fulltraindatapath = fullfile(traindatapath,matfilename);   % 
           load(fulltraindatapath,'smhlabeldata');
           segtrain=smhlabeldata;

           validatapath = config.seg.matvalidata;
           fullvalidatapath = fullfile(validatapath,matfilename);   % 
           load(fullvalidatapath,'smhlabeldata');
           segvali=smhlabeldata;
 
           % create the path to save the model
           % thirdmodelsavepathname = fullfile(config.seg.inittrainedpath,['initSeg_thirdmodel_', matfilename]);
           modelTrVasavepathname = fullfile(config.seg.inittrainedpath,['TrainVali_', matfilename]);
           
       %%%% integrate into the second case.    
       case 'TrainValiTest' % it is the same with case 'TrainVali', but has only one option: the final one.  %% drop this one
           traindatapath = config.seg.mattraindata; 
           matfilename = print_matsegname(fi,config);    
           fulltraindatapath = fullfile(traindatapath,matfilename);   % 
           load(fulltraindatapath,'smhlabeldata');
           segtrain=smhlabeldata;
           validatapath = config.seg.matvalidata;
           fullvalidatapath = fullfile(validatapath,matfilename);   % 
           load(fullvalidatapath,'smhlabeldata');
           segvali=smhlabeldata;
           % create the path to save the model
           finalmodelsavepathname = fullfile(config.seg.inittrainedpath,['initSeg_finalmodel_', matfilename]);
   end

   %% step 2: normalize/scale the grid search data

   % normalize each element of the feature, because different elements in the
   % same feature have different coordinates. The elements of the same feature
   % are independent.
   if exist('segtrain','var') && exist('segvali','var')
      labelgridsearch = double([segtrain(1,:) segvali(1,:)]');
      labelgridsearch( labelgridsearch>1 )= 0;

      datagridsearch = [segtrain(2:end,:) segvali(2:end,:)]';
    
      %% scale training and testing data
      % scale to [-1,1] or [0,1] for the training data
      % scale the testing data according to the threshold [mmmax,mmmin] of the training
      % data
      [scaledatagridsearch,mmmax,mmmin]= svmscaletraindata(datagridsearch,-1,1);
   elseif exist('segtrain','var')
      labelgridsearch = double(segtrain(1,:)');
      labelgridsearch( labelgridsearch>1 )= 0;

      datagridsearch = segtrain(2:end,:)';
    
      %% scale training and testing data
      % scale to [-1,1] or [0,1] for the training data
      % scale the testing data according to the threshold [mmmax,mmmin] of the training
      % data
      [scaledatagridsearch,mmmax,mmmin]= svmscaletraindata(datagridsearch,-1,1);
    
   end 
   downsampledata=scaledatagridsearch(1:2000,:);
   downsamplelabel=labelgridsearch(1:2000,:);
   %% step 3: grid search for the best parameters for SVM (with cross-validation)
   [bestSearch,heat]=svm_gridsearch(downsamplelabel,downsampledata,config); % best for 2000 features, 256, 2
   %% step 4: train the model using the best parameters, get the label for each sample, save the labels.
   switch config.overallmodel,
      case 'Train'
          % option 1
          [svmsmhmodel,~]=svm_gridtrain(downsamplelabel,downsampledata,bestSearch,config);
          %[predict_label, accuracy, dec_values] = svmpredict(labelgridsearch, scaledatagridsearch, svmsmhmodel); 
          save(firstmodelsavepathname,'svmsmhmodel','bestSearch','mmmax','mmmin','-append');
          smhannotations=svm_smhannotations(svmsmhmodel,mmmax,mmmin,config);
          % option 2
      case 'TrainVali'
      case 'TrainValiTest'
   end
   
   

%test_data = (test_data - repmat(minimums, size(test_data, 1), 1)) ./ repmat(ranges, size(test_data, 1), 1);

%http://www.csie.ntu.edu.tw/~cjlin/libsvmtools/eval/matlab/validation_function.m

%https://github.com/mbaytas/libsvm-matlab-basics


end
% convert training data
for flag=1:3,
    if flag==1 && trainflag==1,
        %fulldatapath = fullfile(config.dt.chalearn2014path,config.dt.orgtraindata); % get the path of the training data
        %fullsavepath = fullfile(config.dt.chalearn2014path,config.dt.mattraindata);
        fulldatapath = config.dt.mattraindata;  % get the path of the .mat training data
        fullsavepath = config.seg.mattraindata; % the saving path for segmentation data
    elseif flag==2 && valiflag==1,
        fulldatapath = fullfile(config.dt.chalearn2014path,config.dt.orgvalidata); % get the path of the training data
        fullsavepath = fullfile(config.dt.chalearn2014path,config.dt.matvalidata);
    elseif flag==3 && testflag==1,
        fulldatapath = fullfile(config.dt.chalearn2014path,config.dt.orgtestdata); % get the path of the training data
        fullsavepath = fullfile(config.dt.chalearn2014path,config.dt.mattestdata);
    else
        continue;
    end
    sample_mat= dir([fulldatapath,filesep,'*_Mvideo.mat']); % get all the zip file name
    for fi=1:length(config.seg.featypes),
        
        % for each feature type, saving to a .mat file
        matfilename = print_matsegname(fi,config);   % get the name of the saving file
        savefilepath = fullfile(fullsavepath,matfilename);   % get the full path of the saving file
        smhlabeldata=[]; % save the label and data
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
                  [templabeldata, smhannotation{i}]=read_mhisegmentationdata(modalityData,config);
                  smhlabeldata=[smhlabeldata templabeldata];   % rows: 1+feature size(1 is label);  columns: number of features
               case 'paircase'
           end
        end
        %save(savefilepath, 'smhlabeldata'); 
        %save([savefilepath '.mat'], 'smhlabeldata','smhannotation'); 
        clear modalityData smhlabeldata;
    end 
end

end

