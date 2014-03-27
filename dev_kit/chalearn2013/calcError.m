function error=calcError(prediction,groundTruth)
%
% Compute the Lenvenshtein distance between a file with the predictions and
% the file with the groundtruth. Both files are expected to have the
% following format:
%
%     SampleID,<comma separated sequence of gesture identifiers>
%
% for instance
%
%     Sample00001,2,14,20,6,7,3,1,13,18,5,12,16,15,4,9,10,8,17,19,11
    
    % Import GrounTruth file
    [gtID,gtLabels]=readFile(groundTruth);
    
    % Import prediction file
    [pID,pLabels]=readFile(prediction);
    
    % Compute the sum of generalized Levenshtein distances
    errors=zeros(length(pID),1);
    for i=1:length(pID),
        % Find the position of this sample in the ground truth
        gtPos=find(ismember(gtID,pID(i)),1);
        if isempty(gtPos),
            warning(['Sample ' pId(i) ' not found in ground truth']);
            continue;
        end
        
        % Get ground truth for this sample
        gt=gtLabels{gtPos};
        
        % Get the distance
        errors(i)=levenshtein(gt, pLabels{i});
    end
    
    % Compute the final error value
    error=mean(errors);
end

function [id,labels]=readFile(fileName)
    fid=fopen(fileName);
    
    id={};
    labels={};
    try
        while ~feof(fid),
            % Read the line
            l=fgets(fid);
            % Search first coma
            cpos=find(l==',',1);
            % Get the ID
            id=[id;l(1:cpos-1)];
            % Get the labels
            labels=[labels;l(cpos+1:end)];            
        end
    catch
        
    end
    
    fclose(fid);
end