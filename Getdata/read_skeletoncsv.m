function gesturelabel = read_skeletoncsv(csvpath)    
names={'vattene','vieniqui','perfetto','furbo','cheduepalle','chevuoi','daccordo','seipazzo', ...
       'combinato','freganiente','ok','cosatifarei','basta','prendere','noncenepiu','fame','tantotempo', ...
       'buonissimo','messidaccordo','sonostufo'};
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
        if gstart<1 || gend<1 || gend<=gstart || gid<0 || gid>20,
            warning(['Index error in sample:' csvpath '(Gesture -> ' gid ')']);
            continue;
        else
            gesturelabel(count).id=gid;
            gesturelabel(count).st=gstart;
            gesturelabel(count).ed=gend;
            gesturelabel(count).nm=names{gid};
            tline=fgetl(fid);
        end
    end
end
fclose(fid);
end