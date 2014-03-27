function pathname=printbinaryfilename(sample_fg,config) 
dicsize = config.rfdis3d.dict.size;
if config.gray.flag == 1 && config.depth.flag == 1,
    modality='GrayDepth';
elseif config.gray.flag == 1,
    modality='Gray';
elseif config.depth.flag == 1,
    modality='Depth';
end
if strcmp(sample_fg,'train')
    pathname = ['train_bin_class_' num2str(config.rfdis3d.class.num) '_' num2str(modality) '_sample_'...
                         num2str(config.rfdis3d.data.tr.st) '_t_' num2str(config.rfdis3d.data.tr.ed)...
                         '_' 'fusion' '_' config.rfdis3d.fusion '_dict_' num2str(dicsize)...
                         '_' num2str(config.rfdis3d.llc.tdim) '_llc_' num2str(config.rfdis3d.llc.knn)];  
elseif strcmp(sample_fg,'test')
    pathname = ['test_bin_class_' num2str(config.rfdis3d.class.num) '_' num2str(modality) '_sample_'...
                         num2str(config.rfdis3d.data.tr.st) '_t_' num2str(config.rfdis3d.data.tr.ed)...
                         '_fusion_' config.rfdis3d.fusion '_dict_' num2str(dicsize)...
                         '_' num2str(config.rfdis3d.llc.tdim) '_llc_' num2str(config.rfdis3d.llc.knn)];
end