function scale_testdata= svmscaletestdata(testdata, trmmmin, trmmmax, downthre, upthre)

%ranges = mmmax - mmmin;

if downthre==0 && upthre ==1
scale_testdata = (testdata - repmat(trmmmin, size(testdata, 1), 1)) ./ repmat(trmmmax-trmmmin, size(testdata, 1), 1);
elseif downthre ==-1 && upthre==1
scale_testdata = (testdata - repmat(trmmmin, size(testdata, 1), 1)) ./ repmat(trmmmax-trmmmin, size(testdata, 1), 1)*2-1;

end