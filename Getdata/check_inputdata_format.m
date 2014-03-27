function check_inputdata_format()
dbstop error;
currpath=fileparts(mfilename('fullpath'));
f1path = fathermenu(currpath,1);
f2path = fathermenu(currpath,2);
config.chalearn2014path = f2path;           % will use code to get the path
config.dt.orgtraindata = fullfile(config.chalearn2014path,'ChalearnData','Traindata');     % include the original training data from Chalearn2014 [Train1, Train2, Train3, Train4, Train5]
config.dt.orgvalidata = fullfile(config.chalearn2014path,'ChalearnData','Validata');    % include the original validation data from chalearn2014 [Vali1, Vali2]
config.dt.orgtestdata = fullfile(config.chalearn2014path,'ChalearnData','Testdata');    % include the original testing data from chalearn2014 [Vali1, Vali2]
trainflag=1;
valiflag=0;
testflag=0;

% convert training data
for flag=1:3,
    if flag==1 && trainflag==1,
        %fulldatapath = fullfile(config.dt.chalearn2014path,config.dt.orgtraindata); % get the path of the training data
        %fullsavepath = fullfile(config.dt.chalearn2014path,config.dt.mattraindata);
        fulldatapath = config.dt.orgtraindata; % get the path of the training data
    elseif flag==2 && valiflag==1,
        fulldatapath = fullfile(config.dt.chalearn2014path,config.dt.orgvalidata); % get the path of the training data
        fullsavepath = fullfile(config.dt.chalearn2014path,config.dt.matvalidata);
    elseif flag==3 && testflag==1,
        fulldatapath = fullfile(config.dt.chalearn2014path,config.dt.orgtestdata); % get the path of the training data
        fullsavepath = fullfile(config.dt.chalearn2014path,config.dt.mattestdata);
    else
        continue;
    end
    sample_zip= dir([fulldatapath,filesep,'*.zip']); % get all the zip file name
    for i=1:length(sample_zip),
       % if i >1
        %    continue;
        %end
        samplename = sample_zip(i).name;
        tempsample=fullfile(fulldatapath,samplename);
        [path,sampleID,ext]=fileparts(tempsample);
        sampleDir=fullfile(path,sampleID);
        
        disp(['Check .zip input: ' samplename ' ' num2str(i) ' of ' num2str(length(sample_zip))]);

        unzipsample(tempsample);
        
            % get the sample files directory
        csv_datapath= fullfile(sampleDir,[sampleID '_data.csv']); 
        csv_labelpath= fullfile(sampleDir,[sampleID '_labels.csv']); 
        csv_skelepath= fullfile(sampleDir,[sampleID '_skeleton.csv']); 
    
        video_rgbpath= fullfile(sampleDir,[sampleID '_color.mp4']); 
        video_depthpath= fullfile(sampleDir,[sampleID '_depth.mp4']); 
        video_userpath= fullfile(sampleDir,[sampleID '_user.mp4']); 
     
%         % read the .csv files
%         modalityData =struct();
%         
%         modalityData.samplename=samplename;
%         modalityData.vinfo = read_datacsv(csv_datapath);
%         modalityData.framenum = modalityData.vinfo(1);
%         modalityData.gesturenum = modalityData.vinfo(2);
%         modalityData.depthmax = modalityData.vinfo(3);
%         % 1. Get the skele data
%         [modalityData.sampleskele, modalityData.skeregion]= check_skelecsv(modalityData.framenum,csv_skelepath);  % label = 0 ?
%         % 1.Get the labels and the start and end frame of each gesture, 
%         % 2.labels for all frames
%         [modalityData.samplelabel, modalityData.sampleanno] = check_labelcsv(modalityData,csv_labelpath);  % label = 0 ?
        
        disp('...... Finished!......');  
        removeunzipsample(tempsample);        
    end  
end

end

