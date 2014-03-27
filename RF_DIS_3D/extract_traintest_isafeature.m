function extract_traintest_isafeature(config)

featypes=config.isa.featypes;
%% for different types of modalities, they have different params(e.g. the path of the base filters)
for fi=1:length(featypes),
    if fi==2 && config.depth.flag ~= 1, % whether depth is ready or not?
        break
    end
    [network{fi}, params{fi}]=config_isa_test_networkparams(config,fi);
end
datainfo=config.rfdis3d.data;
pathinfo=config.rfdis3d.path;
classinfo=config.rfdis3d.class;                                  

matisagesturedatapath = pathinfo.saveisafeatures;
saveisadictpath = pathinfo.saveisadictionaries;

exist_make_path(matisagesturedatapath,saveisadictpath);

if (config.parallel.enable && matlabpool('size')==0)
    matlabpool;
end
matorggesturedatapath = config.dt.mattraindata;  % get the path of the .mat training data
for fi=1:1+datainfo.te.lb  % (only train) or (train and test)
    %if fi==1
     %   continue
    %end
    % get the start and end position of the training and testing gestures
    if fi==1
        sample_st=datainfo.tr.st;
        sample_ed=datainfo.tr.ed;
        sample_fg='train';

    else
        sample_st=datainfo.te.st;
        sample_ed=datainfo.te.ed;
        sample_fg='test';
    end
    summary_isapath=printnumofisafeaturepath(sample_fg,saveisadictpath,config);
    tot_sum_isafeats=0;
    % load the index files which includes all the informations of the
    % gestures
    annotations=[];
    count_gesture=0;
    inputfilepathname=fullfile(pathinfo.savedataindex,[datainfo.na '_' sample_fg '_' num2str(classinfo.num) '_' num2str(sample_st) '_t_' num2str(sample_ed) '.mat']);    
    load(inputfilepathname,'annotations','count_gesture');
    for ft=1:length(featypes)
      if ft==2 && config.depth.flag ~= 1, % whether depth is ready or not?
        break
      end
      total_features=zeros(count_gesture,1);
      featclass= featypes{ft};
      network_m= network{ft}; % load the network and params of the modality 'gray'
      params_m = params{ft};
      exist_make_path(fullfile(matisagesturedatapath,featclass));
      if ~config.parallel.enable 
        for i=1:count_gesture
            % each gesture is a .mat file, first get the name of the .mat file,
            % then load the file
            fprintf('%d/%d ',i,count_gesture);

            temp_name=annotations(i).dt;
            hand_flag=annotations(i).hl;
            orggesturedatapath = fullfile(matorggesturedatapath,temp_name);
            % orggesturedata=load(matorggesturedatapath_name);
            saveisafeaturepath= fullfile(matisagesturedatapath,featclass,[temp_name(1:end-4) '_isa.mat']);
            if ~(exist(saveisafeaturepath,'file')==2)
                total_features(i)=extractISAfeature(orggesturedatapath,saveisafeaturepath, hand_flag, featclass, network_m, params_m, config);  
            else
                load(saveisafeaturepath,'t_sp','n_sp')
                total_features(i)=t_sp*n_sp;
                fprintf('exist');
            end
            if mod(i,20)==0
                fprintf('\n %s\n',temp_name(1:end-4));
            end
        end
      else
        parfor i=1:count_gesture
            % each gesture is a .mat file, first get the name of the .mat file,
            % then load the file
            fprintf('%d/%d ',i,count_gesture);

            temp_name=annotations(i).dt;
            hand_flag=annotations(i).hl;
            orggesturedatapath = fullfile(matorggesturedatapath,temp_name);
            % orggesturedata=load(matorggesturedatapath_name);
            saveisafeaturepath= fullfile(matisagesturedatapath,featclass,[temp_name(1:end-4) '_isa.mat']);
            if ~(exist(saveisafeaturepath,'file')==2)
                total_features(i)=extractISAfeature(orggesturedatapath,saveisafeaturepath, hand_flag, featclass, network_m, params_m, config);  
            else
                temptnsp= load(saveisafeaturepath,'t_sp','n_sp');
                total_features(i)=temptnsp.t_sp*temptnsp.n_sp;
                fprintf('exist');
            end
            if mod(i,20)==0
                fprintf('\n %s\n',temp_name(1:end-4));
            end
        end
      end
    end
    tot_sum_isafeats=sum(total_features);
    save(summary_isapath,'tot_sum_isafeats');
end
if (matlabpool('size')>0)
    matlabpool close;
end
end
