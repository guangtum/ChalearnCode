function params = set_isa_network_params(config)

%% number of layers
params.num_isa_layers = config.isa.numlayers;

params.cat_layers = config.isa.catlayers;
params.load_layers_pre = [0,1,2,3];

params.postact = set_postact(config.isa.gpu);


%% fovea sizes
fovea{1}.spatial_size = config.isa.l1.imagesize;
fovea{1}.temporal_size = config.isa.l1.tempesize;

fovea{2}.spatial_size = config.isa.l2.imagesize;
fovea{2}.temporal_size = config.isa.l2.tempesize;

params.fovea = fovea;

%% convolutional strides
stride{1}.spatial_stride = config.isa.l1.imagestride; 
stride{1}.temporal_stride = config.isa.l1.tempestride; % 4

params.stride = stride;
params.sspace = config.isa.samplespace;

%% dense sampling stride
params.ds.imagestride=config.isa.ds.imagestride;
params.ds.tempestride=config.isa.ds.tempestride;

%% network feature dimension and group size
% these are the default settings

params.pca_dim_l1 = config.isa.l1.pcadim; % number of feature dimensions network layer 1
params.group_size_l1 = config.isa.l1.groupsize; % group size

params.pca_dim_l2 = config.isa.l2.pcadim; 
params.group_size_l2 = config.isa.l2.groupsize; 

% results reported in the paper were obtained using group_size_l2 = 4 to 
% save memory on our clusters, but this does not affect results by a lot

params.bases_id{1} = sprintf('sspace_%d_isa1layer_%d_%d_%d_%d', ...
               params.sspace,fovea{1}.spatial_size, fovea{1}.temporal_size, params.pca_dim_l1, params.group_size_l1);

params.bases_id{2} = sprintf('sspace_%d_isa2layer_%dt%d_ts%dt%d_nf%d_gs%d_st%dt%d_l1_%s', params.sspace,...
              fovea{1}.spatial_size, fovea{2}.spatial_size, ...
			  fovea{1}.temporal_size, fovea{2}.temporal_size, ...
			  params.pca_dim_l2, params.group_size_l2, stride{1}.spatial_stride, stride{1}.temporal_stride, params.bases_id{1});

end
