function M = crop_video_blk_spte(M, spatial_size,temperal_size, temperal_stride)
% crops video blk in multiples of given size

    [x, y, t] = size(M);
    cropt = floor((t-temperal_size)/temperal_stride)*temperal_stride+temperal_size;
    M = M(1:floor(x/spatial_size)*spatial_size, 1:floor(y/spatial_size)*spatial_size, 1:cropt);

end