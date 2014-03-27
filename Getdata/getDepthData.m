function frames=getDepthData(videoData,path)

    % Some Windows systems fails on loading mp4 files. In case of error, use
    % alternative reading mode.
    try
        mode=1;
        videoFile = vision.VideoFileReader(path);
    catch
        mode=2;
        videoFile = VideoReader(path);
    end
    if mode==1,
        for i = 1:videoData.NumFrames
            frames{i}=getDepth(step(videoFile),videoData.MaxDepth);
        end
    elseif mode==2,
        for i = 1:videoData.NumFrames
            frames{i}= getDepth(read(videoFile, i),videoData.MaxDepth);
        end
    end
end
function depth = getDepth(frame,maxDepth)
    depth = uint16(round(double(rgb2gray(frame))/255.0*maxDepth));
end