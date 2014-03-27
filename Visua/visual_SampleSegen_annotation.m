%USAGE: drawskt(1,3,1,4,1,2) --- show actions 1,2,3 performed by subjects 1,2,3,4 with instances 1 and 2.
function visual_SampleSegen_annotation()

createConfiguration;
fulldatapath = config.dt.mattraindata;  % get the path of the .mat training data
segmdatapath = fullfile(config.seg.mattraindata,'seg_smh_4x6x1_XYZRxRyRz_MaxAvgMitAit');
sample_mat= dir([fulldatapath,filesep,'*_Mvideo.mat']); % get all the zip file name
annota_mat= dir([segmdatapath,filesep,'*_Mvideo.mat']); % get all the zip file name

matfilepath = print_matsegname(2,config);   % get the name of the saving file
svmannotations = fullfile(config.seg.inittrainedpath,['Annot_Segmentationmodel_', matfilepath, '.mat']);
load(svmannotations,'anno_samples');
for i=1:length(sample_mat), 
    if i>10
        continue;
    end
    annotaname = annota_mat(i).name;
    tempsegmmat=fullfile(segmdatapath,annotaname);
    load(tempsegmmat,'smhannotation');

    annotation_f = smhannotation;
    samplename = sample_mat(i).name;
    tempsample=fullfile(fulldatapath,samplename);
    load(tempsample, 'modalityData');
    skeletondata = modalityData.sampleskele; 
    framenum=size(skeletondata,1);

    lhandpos=0;
    rhandpos=0;
    for j=1:framenum
      lhandpos(j)=skeletondata{j,8}.worldcoord(2);
      rhandpos(j)=skeletondata{j,12}.worldcoord(2);
    end

    x=1:framenum;
    y=0;
    truelabel=modalityData.sampleanno;
    gesturenum=modalityData.gesturenum;
    gesturelabel=modalityData.samplelabel;
    y(x)=0;
    for j=1:gesturenum
       switch gesturelabel(j).hl
         case 'left'
            y(gesturelabel(j).st:gesturelabel(j).ed)=1;
         case 'right'
            y(gesturelabel(j).st:gesturelabel(j).ed)=2;
         case 'both'
            y(gesturelabel(j).st:gesturelabel(j).ed)=3;
       end
    end
%y(truelabel>=1)=4;
    figure;
    subplot(5,1,1);
    plot(x,y,'r-');
    axis([0 framenum 0 4])

    svm_anno=[anno_samples{1,i}];
%     svm_anno(find(svm_anno<0))=-1;
%     svm_anno(find(svm_anno>0.7))= 1;

    subplot(5,1,2);
    plot(x,svm_anno,'r-');
    axis([0 framenum -1 1])

    subplot(5,1,3);
    plot(x,annotation_f,'r-');
    axis([0 framenum 0 5])


    yf=0;
    yf(x)=0;
    for j=1:framenum,
        yf(j)=avefilhand(j,framenum,lhandpos,rhandpos,0.08,4,2);
    end
    deltapos=rhandpos-lhandpos;
    subplot(5,1,4);
    plot(x,deltapos,'b-');
    axis([0 framenum min(deltapos) max(deltapos)])

    subplot(5,1,5);
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
