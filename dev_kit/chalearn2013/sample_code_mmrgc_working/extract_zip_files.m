function extract_zip_files(fname)
% extract_zip_files(fname)
%
% This function extracts the zip files into folders
% 
% fname     -- The path to the folder containing the zip files

% Hugo Jair Escalante -- hugojair@gmail.com -- May 2013

if ~strcmp(fname(end),'\') & ~strcmp(fname(end),'/'),
    fname=[fname '\'];
end
s=dir([fname '*.zip']);
for i=1:length(s),
    i
    if ~exist([fname s(i).name],'dir'),
        mkdir(fname,strrep(s(i).name,'.zip',''));
    end
    unzip([fname s(i).name],[fname strrep(s(i).name,'.zip','')]);
    
end

return;
end


% Errors found on files:
% Sample00243.zip
% Sample00186.zip
% Sample00244.zip