function untitled()
% count_gesture = 50;
% x=1:50;
% y=1:50;
% matlabpool;
% parfor i=1:count_gesture
%                 %fprintf('%d/%d ',i,count_gesture);
%                 accessisafile= x(i);
%                 outputllcfile= y(i);
%                 dispppp(accessisafile,outputllcfile);  
% end
% matlabpool close;


fid1= fopen('x1.txt','wb');
fid2= fopen('x2.txt','wb');
yy=2:90;
for i=1:10
    fwrite(fid1,int32(i),'int');
    fwrite(fid2,int32(yy(i)),'int');
end
fclose(fid1);
fclose(fid2);

fid = fopen('x2.txt', 'rb');
A = fread(fid, 10, 'int')
fclose(fid);

end
function dispppp(x,y)
disp(num2str(x*y));
end