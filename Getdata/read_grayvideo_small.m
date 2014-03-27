function Xcut=read_grayvideo_small(modalityData,path)
    % Some Windows systems fails on loading mp4 files. In case of error, use
    % alternative reading mode.
    skeregion = modalityData.skeregion;
    gesturelabel=modalityData.samplelabel;
    numberframe = gesturelabel(length(gesturelabel)).newed; % get the frame number of the new sequence
    Xcut = uint8(zeros(300,300, numberframe));

    try
        mode=1;
        videoFile = vision.VideoFileReader(path);
    catch
        mode=2;
        videoFile = VideoReader(path);
    end
    if mode==1,
        counter=0; % count the framenumber of the new sequence
        for i = 1:modalityData.framenum
            if ~mod(i,100),
                 disp([num2str(i),' of ',num2str(modalityData.framenum)]);
            end
            temprgb=step(videoFile);
            if modalityData.sampleanno(i)>0
                counter=counter+1;
                Xcut(:,:,counter)=imresize(rgb2gray(temprgb(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw,:)),[300 300]);
                Xcut(:,:,counter)=uint8(round(Xcut(:,:,counter)*255));
            end
            %imshow(Xcut(:,:,i))
            %tempf=rgb2gray(step(videoFile));
            %Xcut(:,:,i)=imresize(tempf(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw),[300 300]);
            %Xcut(:,:,i)=round(Xcut(:,:,i)*255);
        end
        disp('...');
    elseif mode==2,
        counter=0; % count the framenumber of the new sequence
        for i = 1:modalityData.framenum
            if ~mod(i,100),
                 disp([num2str(i),' of ',num2str(modalityData.framenum)]);
            end
            temprgb=read(videoFile, i);
            if modalityData.sampleanno(i)>0
                counter=counter+1;
                Xcut(:,:,counter)=imresize(rgb2gray(temprgb(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw,:)),[300 300]);
                Xcut(:,:,counter)=uint8(round(Xcut(:,:,counter)*255));
            end
            %tempf = rgb2gray(read(videoFile, i));
            %Xcut(:,:,i)=imresize(tempf(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw),[300 300]);
            %Xcut(:,:,i)=round(Xcut(:,:,i)*255);
        end
        %disp('...');
    end
    if counter~=numberframe
        warning(['framenumber error in newsample:' modalityData.samplename ' framenumber1 ' num2str(numberframe) '; framenumber2 ' num2str(counter)]);
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