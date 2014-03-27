function I = fix_frame(I, spatial_size)
global button
% =========
% fix_frame
% =========
% Crops the given image such that the size of the frame is a multiple of
% the spatial size.
%
% Input arguments
% ---------------
% I           : image in 2D array
% spatial_size: spatial size of the filter
%
% Return values
% -------------
% I: cropped image
if strcmp(button,'Depth')
   I_ini=I(:,:,1);
   % fix the hole of the Depth image
   I=fix_frame_hole(I_ini);
else
   I = rgb2gray(I);
end
I = double(I) / 255.0;
[w, h] = size(I);
I = I(1:floor(w/spatial_size)*spatial_size, ...
    1:floor(h/spatial_size)*spatial_size);
