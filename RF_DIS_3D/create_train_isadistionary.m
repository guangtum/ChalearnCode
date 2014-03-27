function create_train_isadistionary(config)
%%%%%%%%%  200 should be changed in the future.

dictinfo  = config.rfdis3d.dict;
datainfo  = config.rfdis3d.data;
pathinfo  = config.rfdis3d.path;
classinfo = config.rfdis3d.class; 
featypes=config.isa.featypes;

isafeaturepath = pathinfo.saveisafeatures;
saveisadictpath = pathinfo.saveisadictionaries;
exist_make_path(saveisadictpath);

sample_st=datainfo.tr.st;
sample_ed=datainfo.tr.ed;
sample_fg='train';
% we need to know the total number of the ISA features
summary_isapath=printnumofisafeaturepath(sample_fg,config);
load(summary_isapath,'tot_num_isafeats');

%% for different types of modalities, they have different dictionaries(e.g. the path of the base filters)
for fi=1:length(featypes),
    if fi==2 && config.depth.flag ~= 1, % whether depth is ready or not?
        break
    end
    
    % where to save the dictionary?
    outputdictpathname=printisadictionarypath(featypes{fi},config);
    exist_make_path(fullfile(isafeaturepath,featypes{fi}));

    % (only using isa features from the training data)
 
    % get the start and end position of the training gestures
    
    % load the index files which includes all the informations of the
    % training gestures
    annotations=[];
    count_gesture=0;
    inputfilepathname=fullfile(pathinfo.savedataindex,[datainfo.na '_' sample_fg '_' num2str(classinfo.num) '_' num2str(sample_st) '_t_' num2str(sample_ed) '.mat']);    
    load(inputfilepathname,'annotations','count_gesture');
    fprintf('kmeans on %d gesture samples from zip. %d to zip %d.\n', count_gesture,sample_st,sample_ed);
    
    num_f_size = min(dictinfo.size*dictinfo.percent, tot_num_isafeats);
    fprintf('kmeans on number of isa features: %d\n', num_f_size);

    % random seed guarantees samples corresponding to same video positions are
    % used % for different bases

    rand('state', dictinfo.seed);

    %down-sample Xtrain_raw
    ridx = randperm(tot_num_isafeats);
    ridx = ridx(1:num_f_size);
    
    line = logical(zeros(tot_num_isafeats, 1));
    line(ridx) = logical(1);
    
    Xtrain_isa_sub = zeros(200,num_f_size,'single'); % org number*size, here we use size*num. see litekmeans_isa.m
    counter  = 1;
    count_st = 1;
    for i=1:count_gesture
        % each isa feature gesture is a .mat file, first get the name of the .mat file,
        % then load the file
        fprintf('%d/%d ',i,count_gesture);
        temp_name=annotations(i).dt;
        % orggesturedata=load(matorggesturedatapath_name);
        isafeaturepathfile= fullfile(isafeaturepath,featypes{fi},[temp_name(1:end-4) '_isa.mat']);
        load(isafeaturepathfile,'Xgray_features'); % Xgray_feature can represent other modalities, although may cause confusion.
        
        blksize = size(Xgray_features,1); % how many blocks in this gesture?
        count_step=sum(line(counter: counter+blksize-1));
        Xtrain_isa_sub(:,count_st:count_st+count_step-1) = Xgray_features(line(counter: counter+blksize-1), :)';
        count_st=count_st+count_step;
        counter = counter + blksize;
        
        clear Xgray_features;
    end
    
    
    assert((count_st-1) == num_f_size);

    assert(counter == (tot_num_isafeats+1));
    for ini_idx = 1:dictinfo.kminit  % I think we only need 1 time(.kminit)
        fprintf('compute kmeans: %d th initialization\n', ini_idx);
        rand('state', dictinfo.seed + 10*ini_idx);
        [~, center_all{ini_idx}, km_obj{ini_idx}] = litekmeans_isa(Xtrain_isa_sub, dictinfo.size);  
    end
    dictionaryisa.(featypes{fi})=center_all{1};
    save(outputdictpathname,'dictionaryisa')
    clear Xtrain_isa_sub;

end
end
%     for j = 1:dictinfo.kminit
%         fprintf('assigning all labels to train data......\n');
%         for i = 1:params.num_vid_sizes
%             train_label_all{j}{i} = find_labels_dnc(center_all{j}, Xtrain_raw{i});
%         end
%     end

