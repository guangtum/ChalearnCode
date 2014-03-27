function matfilename=print_matsegname(i,config)
switch config.seg.featypes{i},
    case 'smh'
       matfilename= sprintf('seg_%s_%dx%dx%d_%s_%s', config.seg.featypes{i}, length(config.seg.smh.classes),config.seg.smh.fspace,config.seg.smh.alin,config.seg.smh.featypes,config.seg.smh.pooling);
    case 'rlh'
       matfilename= sprintf('seg_%s_%dx%dx%d_%s_%s', config.seg.featypes{i}, length(config.seg.rlh.classes),config.seg.rlh.fspace,config.seg.rlh.alin,config.seg.rlh.featypes,config.seg.rlh.pooling);
end
end