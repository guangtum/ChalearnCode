function gestureID=getGestureID(gestureName)
%%
% Get the gesture identifier from their string description
%
%   usage:
%       id=getGestureID('vieniqui');

    % Define the list of available gestures in order (1....N) 
    gestureNameList={'vattene','vieniqui','perfetto','furbo','cheduepalle','chevuoi','daccordo','seipazzo','combinato','freganiente', ...
                     'ok','cosatifarei','basta','prendere','noncenepiu','fame','tantotempo','buonissimo','messidaccordo','sonostufo'};
            
    % Get the position in the array of gestures
    gestureID=find(strcmp(gestureNameList,gestureName));
    
    % Check that this gesture exists
    if isempty(gestureID),
        warning(['Cannot identify gesture: ' gestrureName]);
    end
    
end