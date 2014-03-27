%USAGE: drawskt(1,3,1,4,1,2) --- show actions 1,2,3 performed by subjects 1,2,3,4 with instances 1 and 2.
function visual_SampleSegen()

createConfiguration;
fulldatapath = config.dt.mattraindata;  % get the path of the .mat training data
sample_mat= dir([fulldatapath,filesep,'*_Mvideo.mat']); % get all the zip file name
for i=1:length(sample_mat), 
    if i>2
        continue;
    end
     samplename = sample_mat(i).name;
     tempsample=fullfile(fulldatapath,samplename);
     load(tempsample, 'modalityData');
skeletondata = modalityData.sampleskele;
framenum=size(skeletondata,1);

lhandpos=0;
rhandpos=0;
for i=1:framenum
lhandpos(i)=skeletondata{i,8}.worldcoord(2);
rhandpos(i)=skeletondata{i,12}.worldcoord(2);
end

x=1:framenum;
y=0;
truelabel=modalityData.sampleanno;
gesturenum=modalityData.gesturenum;
gesturelabel=modalityData.samplelabel;
y(x)=0;
for i=1:gesturenum
    switch gesturelabel(i).hl
        case 'left'
            y(gesturelabel(i).st:gesturelabel(i).ed)=1;
        case 'right'
            y(gesturelabel(i).st:gesturelabel(i).ed)=2;
        case 'both'
            y(gesturelabel(i).st:gesturelabel(i).ed)=3;
    end
end
%y(truelabel>=1)=4;
figure;
subplot(3,1,1);
xlim = [1 framenum];
plot(x,y,'r-');
axis([0 framenum 0 4])
yf=0;
yf(x)=0;
for i=1:framenum,
   yf(i)=avefilhand(i,framenum,lhandpos,rhandpos,0.08,4,2);
end
deltapos=rhandpos-lhandpos;
subplot(3,1,2);
xlim = [1 framenum];
plot(x,deltapos,'b-');
axis([0 framenum min(deltapos) max(deltapos)])

subplot(3,1,3);
xlim = [1 framenum];
plot(x,yf,'g-');
axis([0 framenum 0 4])
clear y yf x
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
    length(find(leftside>thresh))
    length(find(rightside>thresh))
    if length(find(leftside>thresh))>=minum ||length(find(rightside>thresh))>=minum % righthand
        handfilt=2;
    elseif length(find((-leftside)>thresh))>=minum || length(find(-rightside>thresh))>=minum % lefthand
        handfilt=1;
    else
        handfilt=0;
    end 
end
end
