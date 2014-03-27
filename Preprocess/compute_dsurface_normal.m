
function normal=compute_dsurface_normal(depth,skeregion)
%
% function normal=compute_surface_normal(depth)
%
depth=double(depth);
pcloud=DepthtoCloud(depth);
pcloudcut=pcloud(skeregion.toplefth:skeregion.bottomrighth,skeregion.topleftw:skeregion.bottomrightw,:);
disp('depth2cloud');
normal=pcnormal(pcloudcut,0.05,5);
disp('finished');
end

