%USAGE: drawskt(1,3,1,4,1,2) --- show actions 1,2,3 performed by subjects 1,2,3,4 with instances 1 and 2.
function visual_3Dskele()
J=[20     1     2     1     8    10     2     9    11     3     4     7     7     5     6    14    15    16    17;
    3     3     3     8    10    12     9    11    13     4     7     5     6    14    15    16    17    18    19];

SkeConMap = [1,2; 2,3 ; 3,4; 3,5; 5,6; 6,7; 7,8; 3,9; 9,10; 10,11; ...
                         11,12; 1,17; 17,18; 18,19 ;19,20; 1,13; 13,14; 14,15; 15,16];
                             
load 'Sample0101_skelab.mat';
skeletondata = modalityData.sampleskele;
framenum=size(skeletondata,1);
if 0
for s=1:framenum
    S=[];
    for jo=1:20
        S=[S; skeletondata{s,jo}.worldcoord(1) skeletondata{s,jo}.worldcoord(2) skeletondata{s,jo}.worldcoord(3)];
    end
    xlim = [-5 5];
    ylim = [-5 5];
    zlim = [-5 5];
    set(gca, 'xlim', xlim, ...
             'ylim', ylim, ...
             'zlim', zlim);
    plot3(S(:,1),S(:,2),S(:,3),'r.','MarkerSize',20);
    hold on
    plot3(S(1,1),S(1,2),S(1,3),'ro','MarkerSize',20);

    %rotate(h,[0 45], -180);
    set(gca,'DataAspectRatio',[1 1 1])
    axis([-1.5 1.5 -1.5 1.5 -1.5 1.5])
    view(-180,-90);
    for j=1:19
        c1=SkeConMap(j,1);
        c2=SkeConMap(j,2);
        line([S(c1,1) S(c2,1)], [S(c1,2) S(c2,2)], [S(c1,3) S(c2,3)],'LineWidth',3);
    end
    xlabel('x-width')
    ylabel('y-height')
    zlabel('z-depth')
    pause(1/10)
    hold off
end

close all
end
for s=1:framenum
    S=[];
    center= [skeletondata{s,1}.worldcoord(1),skeletondata{s,1}.worldcoord(2),skeletondata{s,1}.worldcoord(3)];
    for jo=1:20
        S=[S; skeletondata{s,jo}.worldcoord(1)-center(1) skeletondata{s,jo}.worldcoord(2)-center(2) skeletondata{s,jo}.worldcoord(3)-center(3)];
    end
    xlim = [-5 5];
    ylim = [-5 5];
    zlim = [-5 5];
    set(gca, 'xlim', xlim, ...
             'ylim', ylim, ...
             'zlim', zlim);
    plot3(S(:,1),S(:,2),S(:,3),'r.','MarkerSize',20);
    hold on
    plot3(S(1,1),S(1,2),S(1,3),'ro','MarkerSize',20);

    %rotate(h,[0 45], -180);
    set(gca,'DataAspectRatio',[1 1 1])
    axis([-1.5 1.5 -1.5 1.5 -1.5 1.5])
    view(-180,-90);
    for j=1:19
        c1=SkeConMap(j,1);
        c2=SkeConMap(j,2);
        line([S(c1,1) S(c2,1)], [S(c1,2) S(c2,2)], [S(c1,3) S(c2,3)],'LineWidth',3);
    end
    xlabel('x-width')
    ylabel('y-height')
    zlabel('z-depth')
    pause(1/10)
    hold off
end


file=sprintf('a%02i_s%02i_e%02i_skeleton.txt',20,10,3);
fp=fopen(file);

if (fp>0)
    B=fscanf(fp,'%f');
    fclose(fp);
end


l=size(B,1)/4;
B=reshape(B,4,l);
B=B';
B=reshape(B,20,l/20,4);

X=B(:,:,1);
Z=400-B(:,:,2);
Y=B(:,:,3)/4;
P=B(:,:,4);

for s=1:size(X,2)
    S=[X(:,s) Y(:,s) Z(:,s)];
  
    xlim = [0 800];
    ylim = [0 800];
    zlim = [0 800];
    set(gca, 'xlim', xlim, ...
             'ylim', ylim, ...
             'zlim', zlim);
    h=plot3(S(:,1),S(:,2),S(:,3),'r.','MarkerSize',20);
    %rotate(h,[0 45], -180);
    set(gca,'DataAspectRatio',[1 1 1])
    axis([0 400 0 400 0 400])
    view(0,0);
    for j=1:19
        c1=J(1,j);
        c2=J(2,j);
        line([S(c1,1) S(c2,1)], [S(c1,2) S(c2,2)], [S(c1,3) S(c2,3)],'LineWidth',3);
    end
    pause(1/10)
end