function [skeleton, skeregion] = read_skelecsv(framenum,csvpath)    
%framenum=framenum;
[fid,~] = fopen(csvpath); % csv file, only one line
tline=fgetl(fid);
count = 0;
% hip center 1; Spine 2; ShoulderCenter 3; head 4; ShoulderLeft 5;
% ElbowLeft 6; WristLeft 7; HandLeft 8; ShoulderRight 9; ElbowRight 10;
% WristRight 11; HandRight 12; HipLeft 13; KneeLeft 14; AnkleLeft 15;
% FootLeft 16; HipRight 17; KneeRight 18; AnkleRight 19; FootRight 20;

% we want to know the subject use  right/left hand to perfomed the gesture
avghipw = 0;
avghiph = 0;
avgheadw = 0;
avgheadh = 0;
cnonzero = 0;
while ischar(tline)
        count = count + 1;
        readdata=str2num(tline);
        for i=1:20,
            jointdata=readdata((i-1)*9+1:i*9);
            skeleton{count,i}.worldcoord(1:3)=jointdata(1:3);
            skeleton{count,i}.orients(1:4)= jointdata(4:7);
           % [yaw, pitch, roll] = quat2angle([jointdata(7) jointdata(4:6)]);% yaw pitch roll 
            %if count==10 && i ==8 
                yaw=0;
                pitch=0;
                roll=0;
            %end
            skeleton{count,i}.rpyangle(1:3)= [yaw, pitch, roll];
            skeleton{count,i}.imagecoord(1:2)=jointdata(8:9);
        end
        if skeleton{count,1}.imagecoord(1) ~= 0 && skeleton{count,1}.imagecoord(2) ~=0,
            cnonzero = cnonzero+1;
            avghipw = avghipw + skeleton{count,1}.imagecoord(1);
            avghiph = avghiph + + skeleton{count,1}.imagecoord(2);
            avgheadw = avgheadw + skeleton{count,4}.imagecoord(1);
            avgheadh = avgheadh + skeleton{count,4}.imagecoord(2);
        end
        tline=fgetl(fid);
end
fclose(fid);
avghipw=avghipw/cnonzero;
avghiph=avghiph/cnonzero;
avgheadw=avgheadw/cnonzero;
avgheadh=avgheadh/cnonzero;
skeregion.topleftw=round(max(1,avghipw-(avghiph-avgheadh)*1.1));
skeregion.toplefth=round(max(1,avgheadh-(avghiph-avgheadh)*0.4));
skeregion.bottomrightw=round(min(639,avghipw+(avghiph-avgheadh)*1.1));
skeregion.bottomrighth=round(min(479,avghiph+(avghiph-avgheadh)*0.68));


if count~=framenum
    warning(['Check framenumer.... error in sample:' csvpath ' framenumber1 ' num2str(framenum) '; framenumber2 ' num2str(count)]);
end
end