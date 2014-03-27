function Xcut=read_grayvideo(modalityData,path)
    % Some Windows systems fails on loading mp4 files. In case of error, use
    % alternative reading mode.
    skeregion = modalityData.skeregion;
    Xcut = uint8(zeros(300,300, modalityData.framenum));

    try
        mode=1;
        videoFile = vision.VideoFileReader(path);

    catch
        mode=2;
        videoFile = VideoReader(path);
    end
    if mode==1,
        for i = 1:modalityData.framenum
            if ~mod(i,100),
                 disp([num2str(i),' of ',num2str(modalityData.framenum)]);
            end
            temprgb=step(videoFile);
            tempgray=imresize(rgb2gray(temprgb(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw,:)),[300 300]);
            Xcut(:,:,i)=uint8(round(tempgray*255));
            imshow(Xcut(:,:,i));
            %tempf=rgb2gray(step(videoFile));
            %Xcut(:,:,i)=imresize(tempf(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw),[300 300]);
            %Xcut(:,:,i)=round(Xcut(:,:,i)*255);
        end
        disp('...');
    elseif mode==2,
        for i = 1:modalityData.framenum
            if ~mod(i,100),
                 disp([num2str(i),' of ',num2str(modalityData.framenum)]);
            end
            temprgb=read(videoFile, i);
            tempgray=imresize(rgb2gray(temprgb(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw,:)),[300 300]);
            Xcut(:,:,i)=uint8(round(tempgray*255));
            imshow(Xcut(:,:,i))

            %tempf = rgb2gray(read(videoFile, i));
            %Xcut(:,:,i)=imresize(tempf(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw),[300 300]);
            %Xcut(:,:,i)=round(Xcut(:,:,i)*255);
        end
        %disp('...');
    end
%     if mode==1,
%         gestureid=1;
%         for i = 1:modalityData.framenum
%             if ~mod(i,100),
%                 disp([num2str(i),' of ',num2str(modalityData.framenum)]);
%             end
%             temprgb=step(videoFile);
%             if i>=gesturelabel(gestureid).st && i<=gesturelabel(gestureid).ed;
%                 tempcut=imresize(rgb2gray(temprgb(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw,:)),[300 300]);
%                 Xcut{gestureid}(:,:,i-gesturelabel(gestureid).st+1)=uint8(round(tempcut*255));
%                 if i==gesturelabel(gestureid).ed && gestureid<length(gesturelabel)
%                     gestureid=gestureid+1;
%                 end
%             end
%         end
%         disp('...');
%     elseif mode==2,
%         gestureid=1;
%         for i = 1:modalityData.framenum
%             %disp([num2str(i),' of ',num2str(modalityData.framenum)]);
%             temprgb=read(videoFile, i);
%             if i>=gesturelabel(gestureid).st && i<=gesturelabel(gestureid).ed;
%                 tempcut=imresize(rgb2gray(temprgb(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw,:)),[300 300]);
%                 Xcut{gestureid}(:,:,i-gesturelabel(gestureid).st+1)=uint8(round(tempcut*255));
%                 if i==gesturelabel(gestureid).ed && gestureid<length(gesturelabel)
%                     gestureid=gestureid+1;
%                 end
%             end
%         end
%         disp('...');
%     end

end