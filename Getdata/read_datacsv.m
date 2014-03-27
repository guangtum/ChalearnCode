function readdata = read_datacsv(csvpath)    
[fid,~] = fopen(csvpath); % csv file, only one line
tline=fgetl(fid);
ind = find(tline == ',',2,'first');
if length(ind)~=2
    warning(['The format of the file is wrong: ' csvpath]);
else
    readdata=str2num(tline);
    %numf=readdata(1);
    %numg=readdata(2);
    %maxd=readdata(3);
end
fclose(fid);
end