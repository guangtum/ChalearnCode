function unzipsample(samplePath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unzip the sample
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Split the path and the filename
[path,sampleID,ext]=fileparts(samplePath);
    
% Check that the given file is a zip file
if strcmp(ext,'.zip')~=1,
    warning('Expected a ZIP file as input');
end
       
sampleDir=fullfile(path,sampleID);
if ~exist(sampleDir,'dir'),
      mkdir(sampleDir);
end
if strcmp(ext,'.zip'),
   try
       files=unzip(samplePath,sampleDir);
       if isempty(files),
             warning(['Empty extracted file: ' samplePath]);
       end
   catch
       warning(['Cannot extract file: ' samplePath]);
   end           
end
end