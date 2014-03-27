function scaledata= svmscaletestdata(orgdata, downthre, upthre, scalemax, scalemin)

mmmin = scalemin;
mmmax = scalemax;
%ranges = mmmax - mmmin;
%test_data = (test_data - repmat(minimums, size(test_data, 1), 1)) ./ repmat(ranges, size(test_data, 1), 1);

if downthre ==0 && upthre == 1
scaledata = (orgdata - repmat(mmmin, size(orgdata, 1), 1)) ./ repmat(mmmax-mmmin, size(orgdata, 1), 1);
elseif downthre ==-1 && upthre==1
    scaledata = (orgdata - repmat(mmmin, size(orgdata, 1), 1)) ./ repmat(mmmax-mmmin, size(orgdata, 1), 1)*2-1;
end
end