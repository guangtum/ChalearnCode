function read_mhifeat4trainannot(inputdatapath,savefilepath,config,trainannoflag)
   
sample_mat= dir([inputdatapath,filesep,'*_Mvideo.mat']); % get all the zip file name      
for i=1:length(sample_mat), % sampling data from each samples
    samplename = sample_mat(i).name;
    datasample=fullfile(inputdatapath,samplename);            
    smhfeasavingpathname = fullfile(savefilepath,['smh_feature_' samplename]);
    if ~isempty(find(config.dropsample==i)) && strcmp(config.overallmodel,'Train') %%%%%%%%%%%%%% only for the training dataset
        save(smhfeasavingpathname,'samplename')  
        continue;
    end
    if exist(smhfeasavingpathname,'file')~=2
        save(smhfeasavingpathname,'samplename')  
    else
        disp(['Existing segmentation SMH features ' num2str(i) ' of ' num2str(length(sample_mat))]);
        continue;
        %save(smhfeasavingpathname,'samplename','-append')  
    end
    % get the information/data from each sample
    disp(['Extract segmentation SMH features ' num2str(i) ' of ' num2str(length(sample_mat))]);
    load(datasample, 'modalityData'); 
    % get the data for training the segmentation model
    switch trainannoflag
        case '4train'
            % rows: 1+feature size(1 is label);  columns: number of features
            [smhfeature4train,smhannotation]=read_mhifeat_segtrain(modalityData,config); 
            save(smhfeasavingpathname,'smhfeature4train','smhannotation','-append');  
        case '4annot'
            smhfeature4anno = read_mhifeat_seganno(modalityData,config);  
            save(smhfeasavingpathname,'smhfeature4anno','-append');  
        case '4both'
            [smhfeature4train,smhannotation]=read_mhifeat_segtrain(modalityData,config); 
            smhfeature4anno = read_mhifeat_seganno(modalityData,config);       
            save(smhfeasavingpathname,'smhfeature4train','smhfeature4anno','smhannotation','-append');  
    end
end 
end