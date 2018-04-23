function [rotation, translation] = estimateCameraPoseBetweenFrames(frameOne, frameTwo)
%     (rotation * frameOne) + translation approximates target frame "frameTwo"
    noSamples = 1000;
    
%     sample points randomly
    sampledPoints = samplePoints(frameOne, noSamples, 'random');
    
%     remove 10% worst points ( probably at the edge of the pcd ) based on distance to the franeTwo
    [mins_distance, ~] = getMatchingPoints(sampledPoints, frameTwo);
%     get the index in frameOne
    [~, worsts_idx] = maxk(mins_distance, floor(length(mins_distance)/20));
%     remove them from the sample
    sampledPoints( :, [worsts_idx] ) = [];   
    
    [rotation, translation] = ICP(sampledPoints, frameTwo, 60, 0);
end