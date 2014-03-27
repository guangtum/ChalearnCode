function extract_traintest_llcfeature(config)
%%%%%%%%%  200 should be changed in the future.
if (config.parallel.enable && matlabpool('size')==0)
    matlabpool;
end

dictinfo  = config.rfdis3d.dict;
datainfo  = config.rfdis3d.data;
pathinfo  = config.rfdis3d.path;
classinfo = config.rfdis3d.class; 
llcinfo  = config.rfdis3d.llc;
featypes=config.isa.featypes;

accessisafpath = pathinfo.saveisafeatures;
accessdictpath = pathinfo.saveisadictionaries;
outputllcpath  = pathinfo.savellcfeatures;
exist_make_path(outputllcpath);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for different datasets(e.g. train/test)    
    % for different features(e.g. gray/depth)
        % creat a .mat file (llc features) for each gestures
    % end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for fi=1:1+datainfo.te.lb   
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
    
    % get the annotations and summary of the gestures, the following code
    % will based on the .mat file
    annotations=[];
    count_gesture=0;
    inputfilepathname=fullfile(pathinfo.savedataindex,[datainfo.na '_' sample_fg '_' num2str(classinfo.num) '_' num2str(sample_st) '_t_' num2str(sample_ed) '.mat']);    
    load(inputfilepathname,'annotations','count_gesture');
    
    % for each isa featured gesture--> llc featured gesture
    for j=1:length(featypes)
        if j==2 && config.depth.flag ~= 1, % whether depth is ready or not?
           break
        end
        featclass=featypes{j};
        exist_make_path(fullfile(accessisafpath,featclass));
        exist_make_path(fullfile(outputllcpath,featclass));
        accessdictfile=printisadictionarypath(featclass,config);
        % load the dictionary
        load(accessdictfile,'dictionaryisa');
        mydict=dictionaryisa.(featclass);
        if ~config.parallel.enable 
            for i = 1:count_gesture   
                fprintf('%d/%d ',i,count_gesture);
                temp_name=annotations(i).dt;
                accessisafile= fullfile(accessisafpath,featclass,[temp_name(1:end-4) '_isa.mat']);
                outputllcfile= fullfile(outputllcpath,featclass,[temp_name(1:end-4) '_llc.mat']);
                if ~(exist(outputllcfile,'file')==2)
                    extractLLCfeature(accessisafile,outputllcfile, mydict,config);  
                else
                    fprintf('exist');
                end
                if mod(i,20)==0
                    fprintf('\n %s\n',temp_name(1:end-4));
                end
            end
        else
            parfor i=1:count_gesture
                fprintf('%d/%d ',i,count_gesture);
                temp_name=annotations(i).dt;
                accessisafile= fullfile(accessisafpath,featclass,[temp_name(1:end-4) '_isa.mat']);
                outputllcfile= fullfile(outputllcpath,featclass,[temp_name(1:end-4) '_llc.mat']);
                if ~(exist(outputllcfile,'file')==2)
                    extractLLCfeature(accessisafile,outputllcfile, mydict,config);  
                else
                    fprintf('exist');
                end
                if mod(i,20)==0
                    fprintf('\n %s\n',temp_name(1:end-4));
                end
            end
        end
    end
end
if (matlabpool('size')>0)
    matlabpool close;
end
end
