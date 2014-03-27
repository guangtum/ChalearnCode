%USAGE: drawskt(1,3,1,4,1,2) --- show actions 1,2,3 performed by subjects 1,2,3,4 with instances 1 and 2.
function lranno=right_left_annotation(modalityData)

skeletondata = modalityData.sampleskele;
framenum=size(skeletondata,1);

lhandpos=0;
rhandpos=0;
for i=1:framenum
lhandpos(i)=skeletondata{i,8}.worldcoord(2);
rhandpos(i)=skeletondata{i,12}.worldcoord(2);
end


for i=1:framenum,
   lranno(i)=avefilhand(i,framenum,lhandpos,rhandpos,0.08,4,2);
end
end
function handfilt= avefilhand(i,framenum,lhandpos,rhandpos,thresh,allnum,minum)
if i<allnum,
    rightside(1:allnum)=0;
    for nu=1:allnum
       rightside(nu)=rhandpos(i+nu-1)-lhandpos(i+nu-1);
    end
    if length(find(rightside>thresh))>=minum % righthand
        handfilt=2;
    elseif length(find((-rightside)>thresh))>=minum % lefthand
        handfilt=1;
    else
        handfilt=0;
    end 
elseif i> framenum-allnum+1,
    leftside(1:allnum)=0;
    for nu=1:allnum
       leftside(nu)=rhandpos(i-allnum+nu)-lhandpos(i-allnum+nu);
    end
    if length(find(leftside>thresh))>=minum % righthand
        handfilt=2;
    elseif length(find((-leftside)>thresh))>=minum % lefthand
        handfilt=1;
    else
        handfilt=0;
    end 
else
    leftside(1:allnum)=0;
    for nu=1:allnum
       leftside(nu)=rhandpos(i-allnum+nu)-lhandpos(i-allnum+nu);
    end
    
    rightside(1:allnum)=0;
    for nu=1:allnum
       rightside(nu)=rhandpos(i+nu-1)-lhandpos(i+nu-1);
    end
    length(find(leftside>thresh));
    length(find(rightside>thresh));
    if length(find(leftside>thresh))>=minum ||length(find(rightside>thresh))>=minum % righthand
        handfilt=2;
    elseif length(find((-leftside)>thresh))>=minum || length(find(-rightside>thresh))>=minum % lefthand
        handfilt=1;
    else
        handfilt=0;
    end 
end
end
