function [tempdatalabel,annodata,rlhannotation]=read_rlhfeat_segtrain(modalityData,trainannoflag,config)

% read mhi data from the skeleton data
framenum=modalityData.framenum;
skeletondata=modalityData.sampleskele;
annotation=modalityData.sampleanno;
spacefeat=config.seg.rlh.fspace;
gapfeat=config.seg.rlh.fgap;
% align the skeleton so that all the skeleton has the same hip center (0,0,0)

% compute the distance between right hand and left hand along y axis
% compute the distance between right/left hands and hip center along y axis
% right/left hand joints number
rljoint(1:2)=config.seg.rlh.seljoints;
for s=1:framenum 
    center= [skeletondata{s,1}.worldcoord(1),skeletondata{s,1}.worldcoord(2),skeletondata{s,1}.worldcoord(3)];
    rlhand_ypos(s)=abs(skeletondata{s,rljoint(1)}.worldcoord(2)-skeletondata{s,rljoint(2)}.worldcoord(2));
    rlhand_hip_ypos(s)=max(skeletondata{s,rljoint(1)}.worldcoord(2)-center(2),skeletondata{s,rljoint(2)}.worldcoord(2)-center(2));    
end

missingvaluelabel=ones(1,framenum);

for i=1:framenum % find the frames that have zero values
    if skeletondata{i,1}.imagecoord(1) == 0 || skeletondata{i,1}.imagecoord(2)== 0  
        missingvaluelabel(i)=0;
    end
end

% consider the situation that the skeleton data are zeros. This happens at the
% start of the each sequences.
for i=1:framenum % fix the frames that have zero values
    if missingvaluelabel(i)==0
        indexafter=find(missingvaluelabel(i:end)==1);
        if length(indexafter)>0
            rlhand_ypos(i)=rlhand_ypos(indexafter(1)+i-1);
            rlhand_hip_ypos(i)=rlhand_hip_ypos(indexafter(1)+i-1);  
        else
            indexbefore=find(missingvaluelabel(1:i)==1);
            rlhand_ypos(i)=rlhand_ypos(indexbefore(end));
            rlhand_hip_ypos(i)=rlhand_hip_ypos(indexbefore(end));   
        end
    end
end

rlhannotation=zeros(1,framenum);
% get a very simple model to detect the start and end point of the gestures
% we use the right and left hand different model
lrannotation= right_left_annotation(modalityData);
count=0;
templabel=[];
tempdata=[];
tempdatalabel=[];
rlhannotation=[];
for i=1:framenum % drop the last frame (it is OK)
    for si =i-spacefeat:i+spacefeat
        if si >= 1&& si <= framenum
            tempskeinfo.rlhand_ypos(si-i+spacefeat+1)=rlhand_ypos(si);                    % get the x y x positions under world coordinates
            tempskeinfo.rlhand_hip_ypos(si-i+spacefeat+1)=rlhand_hip_ypos(si);                    % get the x y x positions under world coordinates
        elseif si<1
            tempskeinfo.rlhand_ypos(si-i+spacefeat+1)=rlhand_ypos(1);                    % get the x y x positions under world coordinates
            tempskeinfo.rlhand_hip_ypos(si-i+spacefeat+1)=rlhand_hip_ypos(1);                    % get the x y x positions under world coordinates
        elseif si > framenum
            tempskeinfo.rlhand_ypos(si-i+spacefeat+1)=rlhand_ypos(framenum);                    % get the x y x positions under world coordinates
            tempskeinfo.rlhand_hip_ypos(si-i+spacefeat+1)=rlhand_hip_ypos(framenum);                    % get the x y x positions under world coordinates
        end
    end
    annodata(:,i)=[(tempskeinfo.rlhand_ypos)';max(tempskeinfo.rlhand_ypos(1:spacefeat));min(tempskeinfo.rlhand_ypos(1:spacefeat));...
                                max(tempskeinfo.rlhand_ypos(spacefeat+2:end));min(tempskeinfo.rlhand_ypos(spacefeat+2:end));...
                                mean(tempskeinfo.rlhand_ypos(1:spacefeat));mean(tempskeinfo.rlhand_ypos(spacefeat+2:end));...
            (tempskeinfo.rlhand_hip_ypos)';max(tempskeinfo.rlhand_hip_ypos(1:spacefeat));min(tempskeinfo.rlhand_hip_ypos(1:spacefeat));...
                                max(tempskeinfo.rlhand_hip_ypos(spacefeat+2:end));min(tempskeinfo.rlhand_hip_ypos(spacefeat+2:end));...
                                mean(tempskeinfo.rlhand_hip_ypos(1:spacefeat));mean(tempskeinfo.rlhand_hip_ypos(spacefeat+2:end))];
    
  if i>=(spacefeat+1)&& i<=(framenum-1-spacefeat)&& ~strcmp(trainannoflag,'4annot')
    % frame as the center class 
    if annotation(i)>0 && length(find(annotation(i-spacefeat:i)>0))> 1+gapfeat && length(find(annotation(i:i+spacefeat)>0))> 1+gapfeat
            count=count+1;
            tempdata(:,count)=annodata(:,i);               
            templabel(count)=4;
            rlhannotation(i)=templabel(count);    % frame as the start class
    elseif (length(find(annotation(i-spacefeat:i)>0))>0 && length(find(annotation(i-spacefeat:i)>0))<= 1+gapfeat && length(find(annotation(i:i+spacefeat)>0))>=spacefeat-gapfeat+1) ||...
           (length(find(annotation(i-spacefeat:i)>0))==0 && length(find(annotation(i:i+spacefeat)>0))>=spacefeat-gapfeat+1)
            count=count+1;
            tempdata(:,count)=annodata(:,i);               
            templabel(count)=2;
            rlhannotation(i)=templabel(count);    % frame as the end class    
    elseif (length(find(annotation(i:i+spacefeat)>0))<= 1+gapfeat && length(find(annotation(i:i+spacefeat)>0))> 0 && length(find(annotation(i-spacefeat:i)>0))>=spacefeat-gapfeat+1) ||...
           (length(find(annotation(i:i+spacefeat:i)>0))==0 && length(find(annotation(i-spacefeat:i)>0))>=spacefeat-gapfeat+1)        
            count=count+1;
            tempdata(:,count)=annodata(:,i);               
            templabel(count)=3;
            rlhannotation(i)=templabel(count); % frame as the no gesture class   
    elseif annotation(i)==0 && length(find(annotation(i-spacefeat:i+spacefeat)>0))<=spacefeat-gapfeat ...
            && lrannotation(i)==0 && length(find(lrannotation(i-spacefeat:i+spacefeat)>0))<=spacefeat-gapfeat
            count=count+1;
            tempdata(:,count)=annodata(:,i);               
            templabel(count)=1;
            rlhannotation(i)=templabel(count);
    end 

  
  end
      
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % but we need to consider that some subjects perform gestures that are
    % not included into 20 gestures, but they belongs to center class.
end
annodata=annodata';
tempdatalabel=[templabel;tempdata];
end