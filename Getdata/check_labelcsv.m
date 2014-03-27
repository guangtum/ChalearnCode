function [gesturelabel,anno] = check_labelcsv(modalityData,csvpath)    
names={'vattene','vieniqui','perfetto','furbo','cheduepalle','chevuoi','daccordo','seipazzo', ...
       'combinato','freganiente','ok','cosatifarei','basta','prendere','noncenepiu','fame','tantotempo', ...
       'buonissimo','messidaccordo','sonostufo'};
% hip center 1; Spine 2; ShoulderCenter 3; head 4; ShoulderLeft 5;
% ElbowLeft 6; WristLeft 7; HandLeft 8; ShoulderRight 9; ElbowRight 10;
% WristRight 11; HandRight 12; HipLeft 13; KneeLeft 14; AnkleLeft 15;
% FootLeft 16; HipRight 17; KneeRight 18; AnkleRight 19; FootRight 20;

% use single hand and both hands to perform the gesture 
siordb=[1,1,1,1,2,2,2,1,2,1,1,1,2,1,1,1,1,1,1,1];
% we need to use which hand performs the gesture, this is very important to gesture recognition. 
framenum=modalityData.framenum;

for i=1:framenum
    lhandpos=modalityData.sampleskele{i,8}.worldcoord(2); % left hand position under world coordinates
    rhandpos=modalityData.sampleskele{i,12}.worldcoord(2);% right hand position under world coordinates
    deltalr(i)=lhandpos-rhandpos;
end

anno=zeros(1,framenum);
[fid,~] = fopen(csvpath); % csv file, only one line
tline=fgetl(fid);
ind = find(tline == ',',2,'first');
if length(ind)~=2
    warning(['The format of the file is wrong: ' csvpath]);
else
    count = 0;
    while ischar(tline)
        count = count + 1;
        readdata=str2num(tline);
        gid=readdata(1);
        gstart=readdata(2);
        gend=readdata(3);
        if gstart<1 || gend<1 || gend<=gstart || gid<0 || gid>20 || gend>framenum || gstart>=framenum,
            warning(['Index error in sample:' csvpath '(Gesture -> ' num2str(gid) ')']);
            continue;
        else
            gesturelabel(count).id=gid;
            gesturelabel(count).st=gstart;
            gesturelabel(count).ed=gend;
            
            if count==1
                gesturelabel(count).newst=1;
                gesturelabel(count).newed=gend-gstart+1;
            else
                if gstart<=gesturelabel(count-1).ed
                    warning(['error gesture label in sample:' csvpath '(Gesture -> ' num2str(gid) ')']);
                else
                    gesturelabel(count).newst=gesturelabel(count-1).newed+1;
                    gesturelabel(count).newed=gesturelabel(count-1).newed+1+gend-gstart;
                end
            end
            gesturelabel(count).nm=names{gid};
            % get the hand label for the training gesture data(maybe for the testing data)
            if siordb(gid)~=2,
                if length(find(deltalr(gstart:gend)>0))> length(find(deltalr(gstart:gend)<0)),
                    gesturelabel(count).hl='left';
                else
                    gesturelabel(count).hl='right';
                end

            else
                gesturelabel(count).hl='both';
            end
            
            anno(gesturelabel(count).st:gesturelabel(count).ed)=gesturelabel(count).id;  
            tline=fgetl(fid);
        end
    end
    if count~=modalityData.gesturenum
       warning(['Check Gesture number.... error in sample:' csvpath ' gesnumber1 ' num2str(modalityData.gesturenum) '; gesnumber2 ' num2str(count)]);
    else
       disp('Check framenumber.... Passed!');
    end
    
end
fclose(fid);
end