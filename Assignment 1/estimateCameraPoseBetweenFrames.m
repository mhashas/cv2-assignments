function [rotation, translation] = estimateCameraPoseBetweenFrames(frameOne, frameTwo, sampling)
    
    %(rotation * frameOne) + translation approximates target frame "frameTwo"
    
    [rotation, translation] = ICP(frameOne, frameTwo, 40, sampling, 0, 0);
    
end