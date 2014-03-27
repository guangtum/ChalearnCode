function [] = createMatFilesFg(data, config)
%{
if(config.parallel.enable)
    matlabpool(config.parallel.cores);
end
%}

totalIter = 1;
if(config.includeFlippedImages)
    totalIter = 2;
end

gridSpacing = config.matFiles.gridSpacing;
patchSize = config.matFiles.patchSize;
dictionarySize = config.dictionary.size;
flipSuffix = config.flipSuffix;
imageSets = config.imageSets;
inputFolder = [config.outputFolder '/' data.name '/llc_' num2str(config.dictionary.size) '/'];

for iter=1:totalIter
    flip_str = flipSuffix{iter};
    for iset = 1:length(imageSets)
        imageSet = imageSets{iset};
        currentData = data.(imageSet);
        imageInfo = cell(length(currentData), 1);
        integralData = cell(length(currentData), 1);
        outputFile = fullfile(config.outputFolder, [data.name '/' imageSet flip_str '.mat']);
        
        %parfor i=1:length(currentData)
        for i=1:length(currentData)
            disp(['createMatFiles: ' num2str(i) ' of ' num2str(length(currentData)) ', set: ' imageSet ', flip: ' num2str(iter-1)]);
            inputFile = fullfile(inputFolder, currentData(i).annotation.folder, [currentData(i).annotation.filename(1:end-4) flip_str '.mat']);
            tempData = load(inputFile);
            imageInfo{i}.hgt = tempData.hgt;   % Does this make sense?
            imageInfo{i}.wid = tempData.wid;   % I think one requriment is all the original figures have standard format
            tempData.data = cell2mat(tempData.data);

            [x, y, ~, ~] = generateSIFTGrid(imageInfo{i}.hgt, imageInfo{i}.wid, patchSize, gridSpacing);  %  patchSize is very important, here patchsize is 4
            
            idx = getDistIdx([cell2mat(tempData.x) cell2mat(tempData.y)], [x y]); % but here x has five patchsize, idx calculates the nearest 4sift index of all the five sifts , actually is equal to the position of the 4sift position
            
            overallIdx = cell(length(x), 1); % all five patch index, indexed by index4
            for j=1:length(x)
                overallIdx{j} = find(idx==j); % if some indexs (their values are index4 ) are the same, get their index together 
            end
            nonzero_idx = cellfun(@(x) ~isempty(x),overallIdx);   % non zero values, only the index of the index4 is no zero

            integralData{i} = sparse(length(x), dictionarySize); % config.dictionary.size = 1024;
            integralData{i}(nonzero_idx, :) = cell2mat(cellfun(@(x) max(tempData.data(x, :), [], 1) , overallIdx(nonzero_idx), 'UniformOutput', false)); % max pooling
                                                    % here x means the
                                                    % index groups have the
                                                    % same position
            % here we get a index4 number of llc histograms (for each position, the histogram is the max pooling of different pathces)
            imageInfo{i}.x = x; imageInfo{i}.y = y;
        end
        dataset = currentData;
        save(outputFile, 'dataset',  'integralData', 'imageInfo', '-v7.3'); % the final mat is: for each image, has a matrix to describe it, the column is the number of the LLC feature(or sift feature)
                                                                            % each row means a LLC feature (histogram max pooling), also write down the position of each feature.
    end
end
%{
if(matlabpool('size')>0)
    matlabpool close;
end
%}