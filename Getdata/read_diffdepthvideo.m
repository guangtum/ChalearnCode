function XcutDiff=read_diffdepthvideo(Xcut)

    % Some Windows systems fails on loading mp4 files. In case of error, use
    % alternative reading mode.
    [~,~,D]=size(Xcut);
    %XcutDiff = zeros(rows,cols,D);
    XcutDiff=cal_Diffdepth(Xcut);
    for i = 1:D,
        subplot(121);imshow(Xcut(:,:,i));
        subplot(122);imshow(XcutDiff(:,:,i));
        pause(1/10);
    end
        
end

