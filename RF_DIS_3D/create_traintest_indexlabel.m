function create_traintest_indexlabel(config)

datainfo=config.rfdis3d.data;
pathinfo=config.rfdis3d.path;
classinfo=config.rfdis3d.class;     

sketraindatapath = config.dt.sketraindata;
ziptraindatapath = config.dt.orgtraindata; 
mattraindatapath = config.dt.mattraindata;  % get the path of the .mat training data
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
    
    
    % define the saving file and path
    exist_make_path(pathinfo.savedataindex);
    savefilepathname=fullfile(pathinfo.savedataindex,[datainfo.na '_' sample_fg '_' num2str(classinfo.num) '_' num2str(sample_st) '_t_' num2str(sample_ed) '.mat']);
    % get the name list of the samples' mat file
    %sample_mat= dir([mattraindatapath,filesep,'*_Mvideo.mat']); % get all the zip file name      

    sample_mat= dir([sketraindatapath,filesep,'*_skelabel.mat']); % get all the zip file name      

    % get the label, start, end frame of the gestures in a typical sample
    annotations=[];
    count_gesture=0;
    for i=1:numel(sample_mat)        
        if i <sample_st || i>sample_ed
            continue
        end
        
        samplename = sample_mat(i).name;
        datasample=fullfile(sketraindatapath,samplename); 
        load(datasample, 'modalityData'); % get the sample information from each sample; 
                                          % should we need to consider the
                                          % 21 classes (which means other gestures)
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % 20 classes defined by the chalearn 2014 challenge
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for j=1:modalityData.gesturenum 
            count_gesture=count_gesture+1;          
            annotations(count_gesture).id=modalityData.samplelabel(j).id; % id of the gesture
            annotations(count_gesture).nm=modalityData.samplelabel(j).nm; % name of the gesture
            annotations(count_gesture).st=modalityData.samplelabel(j).st; % start frame
            annotations(count_gesture).ed=modalityData.samplelabel(j).ed; % end frame
            annotations(count_gesture).hl=modalityData.samplelabel(j).hl; % hand label
            annotations(count_gesture).sp=samplename; % the gesture belong to the sample
            annotations(count_gesture).dt=[samplename(1:end-13) '_' num2str(modalityData.samplelabel(j).st) ...
                                       '_' num2str(modalityData.samplelabel(j).ed) '_' num2str(modalityData.samplelabel(j).id) '.mat']; % the gesture belong to the sample

            
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % if we defined that we will use 21 classes and the current sample
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % has the 21th gesture
        if classinfo.num > 20 && numel(modalityData.addedlabel)
            for j=1:numel(modalityData.addedlabel)
                count_gesture=count_gesture+1;          
                annotations(count_gesture).sp=samplename; % the gesture belong to the sample
                annotations(count_gesture).id=modalityData.addedlabel(j).id; % id of the gesture
                annotations(count_gesture).nm=modalityData.addedlabel(j).nm; % name of the gesture
                annotations(count_gesture).st=modalityData.addedlabel(j).st; % start frame
                annotations(count_gesture).ed=modalityData.addedlabel(j).ed; % end frame
                annotations(count_gesture).hl=modalityData.addedlabel(j).hl; % hand label
                annotations(count_gesture).dt=[samplename(1:end-11) '_' num2str(modalityData.addedlabel(j).st) ...
                                       '_' num2str(modalityData.addedlabel(j).ed) '_' num2str(modalityData.addedlabel(j).id) '.mat']; % the gesture belong to the sample

            end
        end
        clear modalityData;         
    end    
    clear annotations;
    save(savefilepathname,'annotations','count_gesture','classinfo','sample_st','sample_ed','sample_fg');     
end
end
