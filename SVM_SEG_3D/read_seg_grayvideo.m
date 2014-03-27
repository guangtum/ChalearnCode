function read_seg_grayvideo(modalityData,savevideodatapath,path)
    % Some Windows systems fails on loading mp4 files. In case of error, use
    % alternative reading mode.
    samplename= modalityData.samplename;
    skeregion = modalityData.skeregion;
    samplelabel= modalityData.samplelabel;

    try
        mode=1;
        videoFile = vision.VideoFileReader(path);

    catch
        mode=2;
        videoFile = VideoReader(path);
    end
    if mode==1,
        gestureid=1;
        for i = 1:modalityData.framenum
            if ~mod(i,100),
                 disp([num2str(i),' of ',num2str(modalityData.framenum)]);
            end
            temprgb=step(videoFile);
            
            if i==samplelabel(gestureid).st
                % initial Xgray
                Xgray = uint8(zeros(300,300,samplelabel(gestureid).ed-samplelabel(gestureid).st+1));
                countf=0;
                % initial saveing file path and name
                filename=[samplename(1:end-4) '_' num2str(samplelabel(gestureid).st) '_' num2str(samplelabel(gestureid).ed) '_' num2str(samplelabel(gestureid).id) '.mat'];
                filenamepath= fullfile(savevideodatapath,filename);
            end
            
            if i>=samplelabel(gestureid).st && i<=samplelabel(gestureid).ed,
                countf=countf+1;
                tempgray=imresize(rgb2gray(temprgb(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw,:)),[300 300]);
                Xgray(:,:,countf)=uint8(round(tempgray*255));
                if i==samplelabel(gestureid).ed && gestureid<length(samplelabel)
                     gestureid=gestureid+1;
                     save(filenamepath,'Xgray');
                end
                if i==samplelabel(gestureid).ed && gestureid==length(samplelabel)
                     save(filenamepath,'Xgray');
                     break;
                end
           end
        end            
    end
end