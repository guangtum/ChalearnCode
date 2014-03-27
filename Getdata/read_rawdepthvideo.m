function Xcut=read_rawdepthvideo(modalityData,path)

    % Some Windows systems fails on loading mp4 files. In case of error, use
    % alternative reading mode.
    skeregion = modalityData.skeregion;

    Xcut = zeros(300,300, modalityData.framenum);
    try
        mode=1;
        videoFile = vision.VideoFileReader(path);
    catch
        mode=2;
        videoFile = VideoReader(path);
    end
    if mode==1,
        for i = 1:modalityData.framenum
            disp([num2str(i),' of ',num2str(modalityData.framenum)]);
            tempdp=step(videoFile);
            tempcut=imresize(tempdp(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw,1),[300 300]);
            Xcut(:,:,i)=tempcut;
            %tempf=getDepth(step(videoFile),modalityData.depthmax);
            %Xcut(:,:,i)=imresize(tempf(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw),[300 300]);
            %Xcut(:,:,i)=uint16(fix_frame_hole(Xcut(:,:,i)));
        end

        
        
        
        
    elseif mode==2,
        gestureid=1;
        for i = 1:modalityData.framenum
            tempdp=read(videoFile, i);
            if i>=gesturelabel(gestureid).st && i<=gesturelabel(gestureid).ed;
                tempcut=imresize(tempdp(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw,1)*modalityData.depthmax,[300 300]);
                Xcut{gestureid}(:,:,i-gesturelabel(gestureid).st+1)=uint16(fix_frame_hole(tempcut));
                if i==gesturelabel(gestureid).ed && gestureid<length(gesturelabel)
                    gestureid=gestureid+1;
                end
            end
        end
    end
end

