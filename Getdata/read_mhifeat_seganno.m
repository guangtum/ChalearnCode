function featuredata=read_mhifeat_seganno(modalityData,config)

% read mhi data from the skeleton data
framenum=modalityData.framenum;
jointsnum=length(config.seg.smh.seljoints);
skeletondata=modalityData.sampleskele;
annotation=modalityData.sampleanno;
spacefeat=config.seg.smh.fspace;
gapfeat=config.seg.smh.fgap;
% align the skeleton so that all the skeleton has the same hip center (0,0,0)
for s=1:framenum
    aligS=[];
    center= [skeletondata{s,1}.worldcoord(1),skeletondata{s,1}.worldcoord(2),skeletondata{s,1}.worldcoord(3)];
    for jo=1:jointsnum
        aligS=[aligS; skeletondata{s,jo}.worldcoord(1)-center(1) skeletondata{s,jo}.worldcoord(2)-center(2) skeletondata{s,jo}.worldcoord(3)-center(3)];
    end
    skealign{s}=aligS;      
end

featuredata=[];
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
            skealign{i}=skealign{indexafter(1)+i-1};                    
            skeletondata{i,1}.rpyangle=skeletondata{indexafter(1)+i-1,1}.rpyangle;
        else
            indexbefore=find(missingvaluelabel(1:i)==1);
            skealign{i}=skealign{indexbefore(end)};                    
            skeletondata{i,1}.rpyangle=skeletondata{indexbefore(end),1}.rpyangle;
        end
    end
end

% get the feature for each frame of the sample
for i=1:framenum
    tempskeinfo=[];    
    for si =i-spacefeat:i+spacefeat
        if si >= 1&& si <= framenum
            tempskeinfo.align{si-i+spacefeat+1}=skealign{si};                    % get the x y x positions under world coordinates
            tempskeinfo.rotat{si-i+spacefeat+1}=skeletondata{si,1}.rpyangle;  % get the yaw pitch roll rotation angles
        elseif si<1
            tempskeinfo.align{si-i+spacefeat+1}=skealign{1};                    % get the x y x positions under world coordinates
            tempskeinfo.rotat{si-i+spacefeat+1}=skeletondata{1,1}.rpyangle;  % get the yaw pitch roll rotation angles  
        elseif si > framenum
            tempskeinfo.align{si-i+spacefeat+1}=skealign{framenum};                    % get the x y x positions under world coordinates
            tempskeinfo.rotat{si-i+spacefeat+1}=skeletondata{framenum,1}.rpyangle;  % get the yaw pitch roll rotation angles  
        end
    end
    featuredata(:,i)=compute_mhifeature(tempskeinfo,config);           
end
featuredata=featuredata';

% scale the feature to the input of the svm model


% get the label for each frame of the sample

end

function fina_xyz=compute_mhifeature(tempskeinfo,config)

skespacexyzpos=tempskeinfo.align;
skespacexyzrot=tempskeinfo.rotat;
spacefeat=config.seg.smh.fspace;

%% feature xyz 3D position
max_xyzpos=[]; % rows: 3(X,YZ)xspacefeat*2   e.g.  3*6*2=36 + 36 + 1 +1 + 1 + 1
avg_xyzpos=[];
max_max_xyzpos=[];
max_avg_xyzpos=[];
final_xyzpos=[];
for i=1:2*spacefeat
    if i<=spacefeat
        max_xyzpos=[max_xyzpos;max(abs(skespacexyzpos{i}-skespacexyzpos{spacefeat+1}))']; 
        avg_xyzpos=[avg_xyzpos;mean(abs(skespacexyzpos{i}-skespacexyzpos{spacefeat+1}))']; 
        max_max_xyzpos=[max_max_xyzpos;max(abs(skespacexyzpos{i}-skespacexyzpos{spacefeat+1}))];
        max_avg_xyzpos=[max_avg_xyzpos;mean(abs(skespacexyzpos{i}-skespacexyzpos{spacefeat+1}))]; 

    else
        max_xyzpos=[max_xyzpos;max(abs(skespacexyzpos{i+1}-skespacexyzpos{spacefeat+1}))'];
        avg_xyzpos=[avg_xyzpos;mean(abs(skespacexyzpos{i+1}-skespacexyzpos{spacefeat+1}))'];
        max_max_xyzpos=[max_max_xyzpos;max(abs(skespacexyzpos{i+1}-skespacexyzpos{spacefeat+1}))];
        max_avg_xyzpos=[max_avg_xyzpos;mean(abs(skespacexyzpos{i+1}-skespacexyzpos{spacefeat+1}))];
    end
end
final_xyzpos=[max_xyzpos;max(max_max_xyzpos(1:spacefeat,:))';max(max_max_xyzpos(1+spacefeat:2*spacefeat,:))'; mean(max_max_xyzpos(1:spacefeat,:))';mean(max_max_xyzpos(1+spacefeat:2*spacefeat,:))';...
              avg_xyzpos;max(max_avg_xyzpos(1:spacefeat,:))';max(max_avg_xyzpos(1+spacefeat:2*spacefeat,:))'; mean(max_avg_xyzpos(1:spacefeat,:))';mean(max_avg_xyzpos(1+spacefeat:2*spacefeat,:))'];

%% feature xyz rotation angle
max_xyzrot=[]; % rows: 3(X,YZ)xspacefeat*2   e.g.  3*6*2=36 + 36 + 1 +1 + 1 + 1
avg_xyzrot=[];
max_max_xyzrot=[];
max_avg_xyzrot=[];
final_xyzrot=[];
for i=1:2*spacefeat
    if i<=spacefeat
        max_xyzrot=[max_xyzrot;max(abs(skespacexyzrot{i}-skespacexyzrot{spacefeat+1}))']; 
        avg_xyzrot=[avg_xyzrot;mean(abs(skespacexyzrot{i}-skespacexyzrot{spacefeat+1}))']; 
        max_max_xyzrot=[max_max_xyzrot;max(abs(skespacexyzrot{i}-skespacexyzrot{spacefeat+1}))];
        max_avg_xyzrot=[max_avg_xyzrot;mean(abs(skespacexyzrot{i}-skespacexyzrot{spacefeat+1}))]; 

    else
        max_xyzrot=[max_xyzrot;max(abs(skespacexyzrot{i+1}-skespacexyzrot{spacefeat+1}))'];
        avg_xyzrot=[avg_xyzrot;mean(abs(skespacexyzrot{i+1}-skespacexyzrot{spacefeat+1}))'];
        max_max_xyzrot=[max_max_xyzrot;max(abs(skespacexyzrot{i+1}-skespacexyzrot{spacefeat+1}))];
        max_avg_xyzrot=[max_avg_xyzrot;mean(abs(skespacexyzrot{i+1}-skespacexyzrot{spacefeat+1}))];
    end
end
final_xyzrot=[max_xyzrot;max(max_max_xyzrot(1:spacefeat,:))';max(max_max_xyzrot(1+spacefeat:2*spacefeat,:))'; mean(max_max_xyzrot(1:spacefeat,:))';mean(max_max_xyzrot(1+spacefeat:2*spacefeat,:))';...
              avg_xyzrot;max(max_avg_xyzrot(1:spacefeat,:))';max(max_avg_xyzrot(1+spacefeat:2*spacefeat,:))'; mean(max_avg_xyzrot(1:spacefeat,:))';mean(max_avg_xyzrot(1+spacefeat:2*spacefeat,:))'];
          
fina_xyz =[final_xyzpos;final_xyzrot];

end