function DiffX=cal_Diffdepth(X)
[rows,cols,D]=size(X);
DiffX=zeros(rows,cols,D);
for i=1:D
    DiffX(:,:,i)=abs(X(:,:,min(D,i+1))-X(:,:,i));
end
end