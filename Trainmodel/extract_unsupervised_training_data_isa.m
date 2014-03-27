function [blocksize]=extract_unsupervised_training_data_isa(train_video_dir, result_file_path, params)
spatial_size = params.spatial_size;
temporal_size = params.temporal_size;
num_blockes = params.num_patches;
modality_type = params.data_type;
sample_zip= dir([train_video_dir,filesep,'Sample*_Mvideo.mat']); % get all the zip file name
fprintf('the number of the training samples: %d\n', length(sample_zip));

blocksnum=0;
for i=1:length(sample_zip),
    samplename     = sample_zip(i).name;
    samplepathname{i} = fullfile(train_video_dir,samplename);
    [~,sampleID,~]=fileparts(samplepathname{i});
    savesamplefile = fullfile(result_file_path,[sampleID,'_Blocks.mat']);
    Xblocks = sample_blocks_pergesture_persample(samplepathname{i}, modality_type, spatial_size, temporal_size, num_blockes);         
    save(savesamplefile, 'Xblocks', 'params');
    blocksnum=blocksnum+size(Xblocks,2);
    clear Xblocks;
end
blocksize=[spatial_size^2*temporal_size,blocksnum];
end

function X = sample_blocks_pergesture_persample(pathsample, modality_type, sp_size, tp_size, num_pergesture)
switch modality_type
   case 'Gray'
      load(pathsample,'modalityData','modalityGray');
      modalityvideo=modalityGray;
      clear modalityGray
   case 'Depth'
      load(pathsample,'modalityData','modalityDepth');
      modalityvideo=modalityDepth;
      clear modalityDepth
   case 'Clora'
      load(pathsample,'modalityData','modalityClora');
      modalityvideo=modalityClora;
      clear modalityClora;
   case 'Clorb'
      load(pathsample,'modalityData','modalityGlarb');
      modalityvideo=modalityClorb;
      clear modalityClorb;
end
num_gestures = modalityData.gesturenum;

X = zeros(sp_size^2*tp_size, num_pergesture*num_gestures);

margin = 1;
counter = 1;

for i = 1 : num_gestures
    fprintf('randomly sampling blockes from: gesture %d/%d in sample %s\n ', i, num_gestures, modalityData.samplename);
    gesstart=modalityData.samplelabel(i).st;
    gesend=modalityData.samplelabel(i).ed;
    M = modalityvideo(:,:,gesstart:gesend);
    % Crops the given image such that the size of the frame is a multiple of
    % the spatial size
    % e.g orgframe_size=(101,202), sp=10, ==> fixframe_size=(100,200)
    
    if strcmp(modalityData.samplelabel(i).hl,'left'), % flip the gesture
        for ti =1:(gesend-gesstart)+1,
            M(:,:,ti)=fliplr(M(:,:,ti));
        end
    end
    
    [dimx, dimy, dimt] = size(M);
    
    for j = 1 : num_pergesture
        %(NOTE) fix the error 
        x_pos = randi([1+margin, dimx-margin-sp_size+1]);
        y_pos = randi([1+margin, dimy-margin-sp_size+1]);
        t_pos = randi([1, dimt-tp_size+1]);
        
        blk = M(x_pos: x_pos+sp_size-1, y_pos: y_pos+sp_size-1, t_pos: t_pos+tp_size-1);
        X(:, counter) = reshape(blk, sp_size^2*tp_size, []);
        counter = counter + 1;
    end
end

end
