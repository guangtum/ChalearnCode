function labels=read_labelanno(modalityData)
% Define an initial label for each frame (0-> no gesture)
labels=zeros(1,modalityData.framenum);

% Number of gestures for this sample
numgest=length(modalityData.samplelabel);

for gn =1: numgest,
    labels(modalityData.samplelabel(gn).st,modalityData.samplelabel(gn).ed)=modalityData.samplelabel(gn).id;  
end
end