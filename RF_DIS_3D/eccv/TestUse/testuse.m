% trainingpath = 'C:\Users\gchen\Dropbox\project\ECCV\TestUse\trainval.txt'; % the list of training data(background)
% savefile = 'VOCActionDataset.mat'; % file name of the dataset
% hi = 'randomforest/images/JPEGImages'; % path where training and test images exist
% name = 'VOC Action Classification'; % name of dataset
% testpath = 'randomforest/llc_extraction/VOC2011ori/Test/VOCdevkit/VOC2011/ImageSets/Action/test.txt';% the list of test data(background)
% 
% guang_generatemat(trainingpath, savefile, hi, name, testpath);


gridSpacing = 4;

patchSize = [8 12 16 24 30];
sigmaEdge = 0.8;
dictionarySize = 256;
knn = 5;

I = imread('C:\Users\gchen\Dropbox\project\ECCV\TestUse\photo-single.jpg');
if ndims(I) == 3
    I = im2double(rgb2gray(I));
else
    I = im2double(I);
end

  % Resize image to appropriate size
  I = imresize(I, min(300/size(I, 1), 300/size(I, 2)));
[hgt wid] = size(I);
x = cell(length(patchSize), 1);  % 5
y = cell(length(patchSize), 1);  % 5
siftDesc = cell(length(patchSize), 1);

for j=1:length(patchSize)
     patchS = patchSize(j);
    [x{j}, y{j}, gridX, gridY] = generateSIFTGrid(hgt, wid, patchS, gridSpacing);  % generate the grid   x and y, the center of the bin; gridX and gridY, the corner of the bin, first column
    siftDesc{j} = sp_normalize_sift(sp_find_sift_grid(I, gridX, gridY, patchS, sigmaEdge));  % normalized sift features
end

% get a random dictionary
%dictionary = rand (256,128);  % 128 is the dimension of the sift descriptors

%input siftDesc{1}=5476X128
dictionary = rand (dictionarySize,128); 
llcHist = cellfun(@(x) sparse(LLC_coding_appr(dictionary, x, knn)), siftDesc, 'UniformOutput', false);  % I think it is not related to the order of the sift descriptors
%output llcHist{1}=5476X256
ddd=full(cell2mat(llcHist{1}));
[codeIndex, LLCValue] = GetSparseDataFunc(ddd(2,:));
% each descriptor corresponding to a histogram ( each of the sum = 1 ), 
matFilespatchSize = 8;

[x2, y2, ~, ~] = generateSIFTGrid(hgt, wid, matFilespatchSize, gridSpacing);
            
idx = getDistIdx([cell2mat(x) cell2mat(y)], [x2 y2]);  % column = sum of five patch

overallIdx = cell(length(x2), 1); % all five patch index, indexed by index4
for j=1:length(x2)
     overallIdx{j} = find(idx==j); % if some indexs (their values are index4 ) are the same, get their index together 
end
nonzero_idx = cellfun(@(x) ~isempty(x),overallIdx);

integralData = sparse(length(x2), dictionarySize); % config.dictionary.size = 1024;
