function segmentatonmodel =  train_singlesample_segsvm(feature_fullpath, modelsavepathname, fnum, config)

% to avoid traing again and again, we 
if exist(modelsavepathname,'file')==2
    load(modelsavepathname,'segmentatonmodel');
    startsample=length(segmentatonmodel)+1;
else
    startsample=1;
end


% get the name list of the smh feature .mat files
feature_sample= dir([feature_fullpath,filesep,config.seg.featypes{fnum},'_feature_*_Mvideo.mat']); % get all the zip file name

% read each feature for each sample, train SVM model for each feature
for i=1:length(feature_sample), % sampling data from each samples
    
    if i < startsample
        disp(['Existing SVM model of sample ' num2str(i) ' of ' num2str(length(feature_sample))]);
        continue
    end
    disp(['Training SVM model of sample ' num2str(i) ' of ' num2str(length(feature_sample))]);
    % some samples with wrong formats, we need to drop these. Note that the
    % feature of this kind of sample is []
    if ~isempty(find(config.dropsample==i)) && strcmp(config.overallmodel,'Train')
        continue;
    end   
    % get the information/data from each sample
    samplename = feature_sample(i).name;
    tempsample=fullfile(feature_fullpath,samplename);
    switch config.seg.featypes{fnum}
        case 'smh'
           load(tempsample, 'smhfeature4train'); 
           feature4train=smhfeature4train;
        case 'rlh'
           load(tempsample, 'rlhfeature4train'); 
           feature4train=rlhfeature4train;

    end
    % prepare SVM input-format data for grid searching of best model
    % parameters
    
    % label, should be double format  mX1 (m is the number of the features)
    labelgridsearch = double(feature4train(1,:)');
    
    % class: no gesture, label: 0
    labelgridsearch(labelgridsearch==1 )= 0; 
    
    % class: gesture, label:1
    labelgridsearch(labelgridsearch>1 )= 1;
    
    % data, m X n (n is the dimension of the feature)
    datagridsearch = feature4train(2:end,:)';

    % scale training data
    % scale to [-1,1] or [0,1] for the training data
    % scale the testing data according to the threshold [mmmax,mmmin] of the training
    % data
    [scaledatagridsearch,mmmax,mmmin]= svmscaletraindata(datagridsearch,-1,1);
      
    % data is ready!
    
    % grid search for the best parameters of each SVM (with 5-fold cross-validation)
    [bestSearch,~]=svm_gridsearch(labelgridsearch,scaledatagridsearch,config); % best for 2000 features, 256, 2
                  
    % training the model with the feature
    [svmsmhmodel,~]=svm_gridtrain(labelgridsearch,scaledatagridsearch,bestSearch,config);
    %[predict_label, accuracy, dec_values] = svmpredict(labelgridsearch, scaledatagridsearch, svmsmhmodel); 
    segmentatonmodel{i}.svmmodel=svmsmhmodel;
    segmentatonmodel{i}.svmparam=bestSearch;
    segmentatonmodel{i}.scalemax=mmmax;
    segmentatonmodel{i}.scalemin=mmmin;
    segmentatonmodel{i}.samplename=samplename;
    save(modelsavepathname,'segmentatonmodel');

end
end
        

