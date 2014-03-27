function frames=getLabeledData(videoData,path)

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
            frames{i}=rgb2gray(step(videoFile));
        end
    elseif mode==2,
        for i = 1:videoData.NumFrames
            frames{i}=rgb2gray(read(videoFile, i));
        end
    end
end