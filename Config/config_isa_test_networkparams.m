function [network, network_params]=config_isa_test_networkparams(config,fi)

featypes=config.isa.featypes;

   %% set up the filter path (where to save the training filter)
unsup_train_filt_path=[config.isa.trainedfiltpath,featypes{fi}];
      
   %% set up network parameters
network_params = set_isa_network_params(config);
network_params.featype=featypes{fi};

%% build multi-isa layer network
network = build_isa_network(network_params, 2, unsup_train_filt_path);


end