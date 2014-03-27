function [] = extractSIFT(data, config)

%{
if(config.parallel.enable && matlabpool('size')==0)
    matlabpool(config.parallel.cores);
end
%}

totalIter = 1;
if(config.includeFlippedImages)
    totalIter = 2;
end

flipSuffix = config.flipSuffix;
outputFolder = [config.outputFolder '/' data.name '/sift/' ];
inputFolder = data.hi;  % 'randomforest/images/JPEGImages'
imageSets = config.imageSets; % config.imageSets = {'tr', 'te'};

%config.SIFT.imageSize = 0;
%config.SIFT.gridSpacing = 4;

%config.SIFT.patchSize = [8 12 16 24 30];
%config.SIFT.sigmaEdge = 0.8;

config = config.SIFT;
patchSizes = config.patchSize;

% Extract SIFT features

for iter=1:totalIter
    config.flipImage = iter-1;
    flip_str = flipSuffix{iter}; % config.flipSuffix = {'', '_f'};
    for iset = 1:length(imageSets)
        imageSet = imageSets{iset};
        currentData = data.(imageSet); % get the name of the current data e.g. 200-21.jpg
        %parfor i=1:length(currentData)
        for i=1:length(currentData)
            disp(['extractSIFT: ' num2str(i) ' of ' num2str(length(currentData)) ', set: ' imageSet ', flip: ' num2str(iter-1)]);

            x = cell(length(patchSizes), 1);  % 5
            y = cell(length(patchSizes), 1);  % 5
            siftDesc = cell(length(patchSizes), 1);

            inputFile = fullfile(inputFolder, currentData(i).annotation.folder, currentData(i).annotation.filename); % get the directory for each image 
            outputFile = fullfile(outputFolder, currentData(i).annotation.folder, [currentData(i).annotation.filename(1:end-4) flip_str '.mat']); % save the sift features for each image as a .mat file (e.g.100 image == 100 .mat)
            if(~exist(outputFile, 'file'))
                make_dir(outputFile);
                I = sp_load_image(inputFile, config);  % read the image  if config.SIFT.imageSize = 0; no resize
                [hgt wid] = size(I);                   % read the size of the image  

                for j=1:length(patchSizes)
                    patchSize = config.patchSize(j);
                    [x{j}, y{j}, gridX, gridY] = generateSIFTGrid(hgt, wid, patchSize, config.gridSpacing);  % generate the grid   x and y, the center of the bin; gridX and gridY, the corner of the bin, first column
                    siftDesc{j} = sp_normalize_sift(sp_find_sift_grid(I, gridX, gridY, patchSize, config.sigmaEdge));  % normalized sift features
                end
                % siftDesc{1}    number of descriptors X 128
                %parsave(outputFile, siftDesc, x, y, patchSizes, hgt, wid);
                
                %  Notice that siftDesc will become the data variable
                saveFileFunc(outputFile, siftDesc, x, y, patchSizes, hgt, wid); %  Because we have five different patchsize, we have five different types of sift descripters
            end                                                                 %  Then we get a ramdom region, and compute the bag of words from the sift descripters falling into this region. is that true?
        end
    end
end
%{
if(matlabpool('size')>0)
    matlabpool close;
end
%}