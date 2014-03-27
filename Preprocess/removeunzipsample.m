function removeunzipsample(samplePath)
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
if ~exist(sampleDir,'dir')
    return
else
    recycleStat=recycle('off');
    try
        rmdir(sampleDir,'s');        
    catch err
        warning(['Cannot remove foler: ' sampleDir ' error: ' err.message]);
    end
    recycle(recycleStat);
end

end