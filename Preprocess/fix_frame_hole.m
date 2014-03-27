function fim = fix_frame_hole(im)
[indzeros(:,1), indzeros(:,2)] = find(im == 0);
index = indzeros;
% recursive median filter
% windows size
fim = im;
wsize = 7;
while size(index,1) > 0
    indtag = zeros(length(index),1);
    for i = 1:size(index,1)
        htop = max(index(i,1) - wsize, 1);
        hbottom = min(index(i,1) + wsize, size(im,1));
        wleft = max(index(i,2) - wsize, 1);
        wright = min(index(i,2) + wsize, size(im,2));
        subim = im(htop:hbottom, wleft: wright);
        subim = subim(:);
        if sum(subim) > 0
            ssubim = subim(subim > 0);
            imrank = sort(ssubim);
            fim(index(i,1),index(i,2)) = imrank(ceil(length(imrank)/2));
            indtag(i) = 1;
        end
    end
    index(indtag>0,:) = [];
    im = fim;
end




















