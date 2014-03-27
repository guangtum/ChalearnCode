function anno_sample_smhseg =  anno_singlesample_segsvm(segmentatonmodel,smhfeature4anno,config)
% input: model, feature(single sample), config
% output: annotations of the single sample(labels for each frame of the
% sample) format: framenumber X 1

% the number of models
nummodel= length(segmentatonmodel);

% data, m X n (m is the number of the frames for a sample, n is the dimension of the feature)
data4svmpredict = smhfeature4anno';

% when predict a svm model, label could be anything
label4svmpredict = ones(size(data4svmpredict,1),1);

predict_anno=zeros(size(data4svmpredict,1),nummodel);
for i =1: nummodel
    % scale the testing data according to the threshold [mmmax,mmmin] of the training
    % data
    data4svmpredict_scale= svmscaletestdata(data4svmpredict,-1,1,segmentatonmodel.scalemax,segmentatonmodel.scalemin);
    
    % predict the label of each frame in the sample
    [predict_anno(:,i), ~, ~] = svmpredict(label4svmpredict, data4svmpredict_scale, segmentatonmodel.svmmodel); 
end

% vote the majority of the labels
anno_sample_smhseg=sum(predict_anno,2);

end

