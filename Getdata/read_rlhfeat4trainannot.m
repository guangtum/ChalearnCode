function read_rlhfeat4trainannot(inputdatapath,savefilepath,config,trainannoflag)
   
sample_mat= dir([inputdatapath,filesep,'*_Mvideo.mat']); % get all the zip file name      
for i=1:length(sample_mat), % sampling data from each samples
    samplename = sample_mat(i).name;
    datasample=fullfile(inputdatapath,samplename);            
    rlhfeasavingpathname = fullfile(savefilepath,['rlh_feature_' samplename]);
    if ~isempty(find(config.dropsample==i)) && strcmp(config.overallmodel,'Train') %%%%%%%%%%%%%% only for the training dataset
        save(rlhfeasavingpathname,'samplename')  
        continue;
    end
    if exist(rlhfeasavingpathname,'file')~=2
        save(rlhfeasavingpathname,'samplename')  
    else
        save(rlhfeasavingpathname,'samplename','-append')  
    end
    % get the information/data from each sample
    disp(['Extract segmentation RLH features ' num2str(i) ' of ' num2str(length(sample_mat))]);
    load(datasample, 'modalityData'); 
    % get the data for training the segmentation model
    [rlhfeature4train,rlhfeature4anno,rlhannotation]=read_rlhfeat_segtrain(modalityData,trainannoflag,config); 
    save(rlhfeasavingpathname,'rlhfeature4train','rlhfeature4anno','rlhannotation','-append');  
%     switch trainannoflag
%         case '4train'
%             % rows: 1+feature size(1 is label);  columns: number of features
%             [rlhfeature4train,rlhfeature4anno,rlhannotation]=read_rlhfeat_segtrain(modalityData,trainannoflag,config); 
%             save(rlhfeasavingpathname,'rlhfeature4train','rlhannotation','-append');  
%         case '4annot'
%             rlhfeature4anno = read_rlhfeat_seganno(modalityData,config);  
%             save(rlhfeasavingpathname,'rlhfeature4anno','-append');  
%         case '4both'
%             [rlhfeature4train,rlhannotation]=read_rlhfeat_segtrain(modalityData,config); 
%             rlhfeature4anno = read_rlhfeat_seganno(modalityData,config);       
%             save(rlhfeasavingpathname,'rlhfeature4train','rlhfeature4anno','rlhannotation','-append');  
%     end
end 
end