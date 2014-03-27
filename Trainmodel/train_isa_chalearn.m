%train stacked ISA
%this function trains bases for layers of stacked isa model

function [] = train_isa_chalearn(network, train_data_filename, samplespace, blocksize, bases_path, params)

fprintf('\n----------------------------------------\n');
fprintf('start training layer %d\n', params.layer);
filename = fullfile(bases_path, [network.isa{params.layer}.bases_id '.mat']);
if exist(filename,'file')==2
    disp([filename 'already trained!']);
    return
end


fprintf('------- load training blockes from samples: --------- \n');
blocks_mat= dir([train_data_filename,filesep,'Sample*_Blocks.mat']); % get all the blocks.mat file

X = single(zeros(blocksize(1), length(1:samplespace:blocksize(2))-800));
counter=0;
dataready=0;
for i=1:length(blocks_mat),
    blocksamplename     = blocks_mat(i).name;
    blocksample = fullfile(train_data_filename,blocksamplename);    
    load(blocksample,'Xblocks');
    disp(['load blocks for trainng ISA model ' blocksamplename ' of ' num2str(i)])
    if counter+length(1:samplespace:size(Xblocks,2))<size(X,2),
        X(:,(counter+1):(counter+length(1:samplespace:size(Xblocks,2))))=Xblocks(:,1:samplespace:size(Xblocks,2));
        counter=counter+length(1:samplespace:size(Xblocks,2));
    elseif counter+length(1:samplespace:size(Xblocks,2))==size(X,2),
        X(:,(counter+1):(counter+length(1:samplespace:size(Xblocks,2))))=Xblocks(:,1:samplespace:size(Xblocks,2));
        fprintf('------- finished loading training blockes from samples: --------- \n');
        dataready=1;
        break;
    else
        X(:,(counter+1):size(X,2))=Xblocks(:,1:(size(X,2)-counter));
        fprintf('------- finished loading training blockes from samples: --------- \n');
        dataready=1;
        break;
    end
    disp(['size of training data ' num2str(counter) ' of ' num2str(size(X,2))]);

    clear Xblocks
end

if dataready==0
    errordlg('The input data to ISA is not right!');
    return
end

if params.layer ==2
    fprintf('------- Forw Prop layer 1: --------- \n');

    X = single(transactConvISA(X, network.isa{1}, network.isa{2}, params.postact.layer1));
elseif params.layer ==3
    fprintf('------- Forw Prop layers 1 and 2: --------- \n');   
    [X, ~, ~, ~, act_l1_pool_list] = transactConvISA2layers(network, X, params.pool_type, params.postact);    
end

fprintf('size of X: %dx%d\n', size(X,1), size(X,2));

fprintf('Removing DC component\n')

%MeanX=uint8(zeros(size(X,1),size(X,2)));

X=single(X-repmat(mean(X),size(X,1),1));

%X = removeDC(X);
%X = X-MeanX;


if params.layer ==3
    act_l1_pool_list = removeDC(act_l1_pool_list);
end

fprintf('Doing PCA and whitening on data or prev layer activations\n')

% [V,E,D] = pca(X);
[V] = pca(X);

if params.layer ==3
    fprintf('Doing PCA and whitening on layer 1 (reduced) activations\n')
    
    [V_l1l2, E, D] = pca(act_l1_pool_list);
end

Z = V(1:params.pca_dim , :)*X;

save_filename = fullfile(bases_path, [network.isa{params.layer}.bases_id '.mat']);

fprintf('saving bases at %s\n', save_filename);

if params.layer ==3
    isa_est(Z,V(1:params.pca_dim,:), params.pca_dim, params.group_size, network.isa{params.layer}.fovea.spatial_size, network.isa{params.layer}.fovea.temporal_size, save_filename, V_l1l2(1:params.pca_dim,:));
else
    isa_est(Z,V(1:params.pca_dim,:), params.pca_dim, params.group_size, network.isa{params.layer}.fovea.spatial_size, network.isa{params.layer}.fovea.temporal_size, save_filename);
end

end
