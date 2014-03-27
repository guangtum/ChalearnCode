function [scaledata, mmmax, mmmin]= svmscaletraindata(orgdata, downthre, upthre)

mmmin = min(orgdata, [], 1);
mmmax = max(orgdata, [], 1);
%ranges = mmmax - mmmin;

if downthre ==0 && upthre == 1
scaledata = (orgdata - repmat(mmmin, size(orgdata, 1), 1)) ./ repmat(mmmax-mmmin, size(orgdata, 1), 1);
elseif downthre ==-1 && upthre==1
    scaledata = (orgdata - repmat(mmmin, size(orgdata, 1), 1)) ./ repmat(mmmax-mmmin, size(orgdata, 1), 1)*2-1;
end
end