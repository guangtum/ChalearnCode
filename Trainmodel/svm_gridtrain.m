function [svmsmhmodel,params]=svm_gridtrain(labels,features,bestsearch,config)
% Train with best cost & gamma
params = ['-q -t ' num2str(config.seg.gs.kernel_type) ' -c ', num2str(bestsearch(1)), ' -g ', num2str(bestsearch(2))];
svmsmhmodel = svmtrain(labels, features, params);   
end