function exist_make_path(path1,path2,path3,path4,path5) 
if nargin<2
    pathall={path1};
elseif nargin<3
    pathall={path1,path2};
elseif nargin<4
    pathall={path1,path2,path3};
elseif nargin<5
    pathall={path1,path2,path3,path4};
else
    pathall={path1,path2,path3,path4,path5};
    
end
%disp(pathall);
for i=1:nargin
    if exist(pathall{i},'dir')~=7
         mkdir(pathall{i})
    end
end
end


