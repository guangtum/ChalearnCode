function [topview sideview]=read_topsidevideo(modalityData,path)

    % Some Windows systems fails on loading mp4 files. In case of error, use
    % alternative reading mode.
    skeregion = modalityData.skeregion;
    try
        mode=1;
        videoFile = vision.VideoFileReader(path);
    catch
        mode=2;
        videoFile = VideoReader(path);
    end
    if mode==1,
        for i = 1:modalityData.framenum
            tempdepth=double(getDepth(step(videoFile),modalityData.depthmax));
            pcloud=DepthtoCloud(tempdepth);
            pcloudcut=pcloud(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw,:);
        end
    elseif mode==2,
        for i = 1:modalityData.framenum
            tempdepth= getDepth(read(videoFile, i),modalityData.depthmax);
            normal{i}=compute_dsurface_normal(tempdepth);

        end
    end
end

function depth = getDepth(frame,maxDepth)
    depth = uint16(round(double(rgb2gray(frame))*maxDepth));
end