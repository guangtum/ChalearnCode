function [Xcuta,Xcutb]=read_labvideo(modalityData,path)
    % Some Windows systems fails on loading mp4 files. In case of error, use
    % alternative reading mode.
    skeregion = modalityData.skeregion;

    Xcuta = zeros(300,300, modalityData.framenum);
    Xcutb = zeros(300,300, modalityData.framenum);

    try
        mode=1;
        videoFile = vision.VideoFileReader(path);
    catch
        mode=2;
        videoFile = VideoReader(path);
    end
    if mode==1,
        for i = 1:modalityData.framenum
            %if ~mod(i,10),
           %     disp([num2str(i),' of ',num2str(modalityData.framenum)]);
            %end
            [~,framea,frameb]=RGB2Lab(step(videoFile));       
            Xcuta(:,:,i)=imresize(framea(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw),[300 300]);
            Xcutb(:,:,i)=imresize(frameb(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw),[300 300]);

        end
    elseif mode==2,
        for i = 1:modalityData.framenum
            %disp([num2str(i),' of ',num2str(modalityData.framenum)]);
            [~,framea,frameb]=RGB2Lab(read(videoFile, i));       
            Xcuta(:,:,i)=imresize(framea(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw),[300 300]);
            Xcutb(:,:,i)=imresize(frameb(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw),[300 300]);       
        end
    end
end