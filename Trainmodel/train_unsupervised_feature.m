function train_unsupervised_feature(config)
%% train unsupervised learning features from the training data
disp('train unsupervised learning features from the training data:');
disp(config.isa.featypes);

featypes=config.isa.featypes;
%% start training
for ft=1:length(featypes),
   disp(['trainning with the modality: ',featypes{ft}]);
   
   %% set up the filter path (where to save the training filter)
   unsup_train_filt_path=[config.isa.trainedfiltpath,featypes{ft}];
   unsup_train_data_path=[config.isa.mattraindata,featypes{ft}];
   exist_make_path(unsup_train_filt_path,unsup_train_data_path);
   
   %% set up randomly sampling parameters
   num_unsup_samples_per_gesture = config.isa.unsupsamplespergesture;
   
   %% set up network parameters
   network_params = set_isa_network_params(config);
   network_params.featype=featypes{ft};
   
   %% build multi-isa layer network
   network = build_isa_network(network_params, network_params.load_layers_pre(1), unsup_train_filt_path);
   
   %% locate unsupervised training data
   for i = 1:network.num_isa_layers
      data_file_name{i} = sprintf('blktrain_%dx%dx%d_np%d', network.isa{i}.fovea.spatial_size,network.isa{i}.fovea.spatial_size, network.isa{i}.fovea.temporal_size, num_unsup_samples_per_gesture(i));
      data_path_file_name{i} = fullfile(unsup_train_data_path, data_file_name{i});
      exist_make_path(data_path_file_name{i});
      fprintf('accessing sampled data at: %s\n', data_path_file_name{i});
   end
   
   %% sample unsup training data
   blocksize=[2048,1369400;4000,1369400;0,0;0,0];   
   
%    blocksize=[0,0;0,0;0,0;0,0];   
%    for i = 1:network.num_isa_layers %1 and 2 layers (since 3rd layer is the same size)       
%       params_ex.spatial_size = network.isa{i}.fovea.spatial_size;
%       params_ex.temporal_size = network.isa{i}.fovea.temporal_size;
%       params_ex.num_patches = num_unsup_samples_per_gesture(i);    
%       params_ex.data_type = network_params.featype;   
%     
%       %% extract data   
%       blocksize(i,:)=extract_unsupervised_training_data_isa(config.dt.mattraindata, data_path_file_name{i}, params_ex);       
%    end
   
   %% execute multi-layer isa model training
   for i = 1:network.num_isa_layers
           
       if i==1, % train layer 1
          train_isa_chalearn(network, data_path_file_name{i}, config.isa.samplespace, blocksize(i,:),unsup_train_filt_path, set_training_params(i, network_params));
       else     % train other layers
          % the different layers have different 'networks', here we updata
          % the network for each layer(except layer 1)
          network = build_isa_network(network_params, network_params.load_layers_pre(i),unsup_train_filt_path);
          train_isa_chalearn(network, data_path_file_name{i}, config.isa.samplespace, blocksize(i,:),unsup_train_filt_path, set_training_params(i, network_params));
       end
   end
end
end