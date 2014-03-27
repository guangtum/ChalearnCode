function output_binaryFeature_4mex(config)
% this script output binary files
%% if config.rfdis3d.fusion = '2_3'. 
% we save different binary files for different time windows (default)
% if config.rfdis3d.fusion = '2_2'. 
% we save only one binary files for different time windows; maxpooling(t1,t2,t3...t10)
% if config.rfdis3d.fusion = '2_1'. 
% we save only one binary files for different time windows; t1+t2+t3+...+t10
% if config.rfdis3d.fusion = '1_3'. 
% We fusion data, then train the dictionary. independent 
% if config.rfdis3d.fusion = '1_2'. 
% We fusion data, then train the dictionary. maxpooling 
% if config.rfdis3d.fusion = '1_2'. 
% We fusion data, then train the dictionary. ++++++++++
%%%%%%%%%  200 should be changed in the future.
datainfo  = config.rfdis3d.data;
pathinfo  = config.rfdis3d.path;
classinfo = config.rfdis3d.class; 
llcinfo  = config.rfdis3d.llc;
featypes=config.isa.featypes;

outputbinpath = pathinfo.savebinfeatures;
accessllcpath  = pathinfo.savellcfeatures;
accessidxpath  = pathinfo.savedataindex;
exist_make_path(outputbinpath);

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
    savebinname=printbinaryfilename(sample_fg,config);
    % get the annotations and summary of the gestures, the following code
    % will based on the .mat file
    annotations=[];
    count_gesture=0;
    inputfilepathname=fullfile(accessidxpath,[datainfo.na '_' sample_fg '_' num2str(classinfo.num) '_' num2str(sample_st) '_t_' num2str(sample_ed) '.mat']);    
    load(inputfilepathname,'annotations','count_gesture');
    for ti=1:llcinfo.tdim
        % the name and full path of the binary files
        
        outputbinfile=fullfile(outputbinpath,[savebinname, '_twindows_' num2str(ti) '.txt']);
        %************************** save overall gesture numbers (e.g. 2000)
        fprintf('write binary file %s\n',outputbinfile);

        fid = fopen(outputbinfile,'wb');
        fwrite(fid,int32(count_gesture),'int'); 
        
        % input file; llc features for each gesture
        if config.gray.flag == 1 && config.depth.flag == 1,
            featclass='GrayDepth';
        elseif config.gray.flag == 1,
            featclass='Gray';
        elseif config.depth.flag == 1,
            featclass='Depth';
        end
        temp_class=-1;
        for i = 1:count_gesture   
            fprintf('%d/%d ',i,count_gesture);
            temp_name=annotations(i).dt;
            % load llc features
            accessllcfile= fullfile(accessllcpath,featclass,[temp_name(1:end-4) '_llc.mat']);
            load(accessllcfile,'llcfeaturedata','gestureinfo');
            
            % we only need current windos times llc features and gesture
            % informations
            current_ti_llc = llcfeaturedata{ti};
            current_ti_ges = gestureinfo{ti};
            %************************** save class labels for current
            %gesture (e.g.  10)
            fwrite(fid, int32(annotations(i).id),'int');
            fwrite(fid, int32(temp_class),'int');
            width=numel(current_ti_ges.y);
            height=numel(current_ti_ges.x);
            %************************** save width and height
            fwrite(fid, int32(width),'int');
            fwrite(fid, int32(height),'int');
            start_id = 0;
            %************************** save start id of each llc feature
            fwrite(fid, int32(start_id),'int');
            for j=1:size(current_ti_llc,1)
                % we want to know how may feature are nozeros.
                start_id=start_id+numel(find(current_ti_llc(j,:)~=0));
                %************************** save end id of cur llc feature,
                %equs to the star_id of the next llc feature
                fwrite(fid,int32(start_id),'int'); 
            end
            [codeindex, LLCValue] = GetSparseDataFunc(current_ti_llc);
            fwrite(fid,int32(codeindex),'int'); 
            fwrite(fid,single(LLCValue),'single');
        end
        fclose(fid);
    end
end
end
