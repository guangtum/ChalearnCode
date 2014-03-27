function pathname=printisadictionarypath(modality,config)   
    pathdict = config.rfdis3d.path.saveisadictionaries;
    dicsize = config.rfdis3d.dict.size;
    dicper = config.rfdis3d.dict.percent;
    pathname = fullfile(pathdict,['dict_' modality '_' num2str(dicsize) '_' num2str(dicper) '_' num2str(config.rfdis3d.class.num) '_sample_'...
                         num2str(config.rfdis3d.data.tr.st) '_t_' num2str(config.rfdis3d.data.tr.ed)...
                         '_' num2str(config.isa.l2.imagesize) '_size_' num2str(config.isa.l2.tempesize)...
                         '_' num2str(config.isa.ds.imagestride) '_stride_' num2str(config.isa.ds.tempestride) '.mat']);
    
end