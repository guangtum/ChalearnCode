function [bestSearch,heat]=svm_gridsearch(labels,features,config)
log2cList=config.seg.gs.log2cList;
log2gList=config.seg.gs.log2gList;
Nlog2c = length(log2cList);
Nlog2g = length(log2gList);
heat = zeros(Nlog2c,Nlog2g); % Init heatmap matrix
bestAccuracy = 0; % Var to store best accuracy

% balance the training data
n_total = size(labels,1);
n_pos = sum(labels);
n_neg = n_total-n_pos;
        
% positive and negative weights balanced with number of positive and negative examples
w_pos = n_total/(2*n_pos);
w_neg = n_total/(2*n_neg);
w_1=w_pos;
w_0=w_neg; 

% To see how things go as grid search runs
totalRuns = Nlog2c*Nlog2g;
runCounter = 1;
for i = 1:Nlog2c
    for j = 1:Nlog2g
        log2c = log2cList(i);
        log2g = log2gList(j);
        %disp([num2str(runCounter), '/', num2str(totalRuns)]);
        %disp(['Trying c=', num2str(2^log2c), ' and g=', num2str(2^log2g)]);
        % Train with current cost & gamma
        params = ['-q -t ' num2str(config.seg.gs.kernel_type) ' -w1 ' num2str(w_1) ' -w0 ' num2str(w_0) ' -v ' num2str(config.seg.gs.k_fold) ' -c ', num2str(2^log2c), ' -g ', num2str(2^log2g)];
        accuracy = svmtrain(labels, features, params);
        % Update heatmap matrix
        heat(i,j) = accuracy;
        % Update accuracy, cost & gamma if better
        if (accuracy >= bestAccuracy)
            bestAccuracy = accuracy;
            bestC = 2^log2c;
            bestG = 2^log2g;
        end
        runCounter = runCounter+1;
    end
end
bestSearch = [bestC,bestG,bestAccuracy];
disp('Finished Grid Search Parameters');
end