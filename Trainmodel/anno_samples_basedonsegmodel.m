function anno_samples_basedonsegmodel(annotdatapath,modelsegpath,saveannotations,fi,config)

% load the model
load(modelsegpath,'segmentatonmodel');
featurety=config.seg.featypes{fi};
    
% get the name list of the smh feature .mat files
smh_feature_sample= dir([annotdatapath,filesep,featurety,'_feature_*_Mvideo.mat']); % get all the zip file name

% read features (for each frame) of each sample, annotate the sample based on the train SVM model
for i=1:length(smh_feature_sample), % sampling data from each samples
    
    disp(['annotation the sample ' smh_feature_sample(i).name]);
    % some samples with wrong formats, we need to drop these. Note that the
    % feature of this kind of sample is []
    if (~isempty(find(config.dropsample==i)) && strcmp(config.overallmodel,'Train')) || i>10
        continue;
    end   
    % get the information/data from each sample
    samplename = smh_feature_sample(i).name;
    tempsample=fullfile(annotdatapath,samplename);
    switch featurety
        case 'smh'
           load(tempsample, 'smhfeature4anno');    
           anno_samples{i} =  anno_singlesample_segsvm(segmentatonmodel,smhfeature4anno,config);
        case 'rlh'
           load(tempsample, 'rlhfeature4anno');    
           anno_samples{i} =  anno_singlesample_segsvm(segmentatonmodel,rlhfeature4anno,config);
end
save(saveannotations,'anno_samples');
   
end
        

