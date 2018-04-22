function [rotation, translation] = estimateCameraPoseBetweenFrames(frameOne, frameTwo)
%     (rotation * frameOne) + translation approximates target frame "frameTwo"
    noSamples = 1000;
    
    sampledPoints = samplePoints(frameOne, noSamples, 'random');
    [rotation, translation] = ICP(sampledPoints, frameTwo, 40, 0);
end