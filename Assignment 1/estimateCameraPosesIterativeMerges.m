function poses = estimateCameraPosesIterativeMerges(frames, frameSamplingRate, startFrame, endFrame)
    switch nargin
        case 4
            startFrame = startFrame;
            endFrame = endFrame;
        otherwise
            startFrame = 1;
            endFrame = length(frames);
    end
    
 sampledFrames = frames(startFrame:frameSamplingRate:endFrame);
 
 mergedFrames = sampledFrames(1).points';
    for i=2:length(sampledFrames)
        fprintf("Frame number:%d\n",(i-1)*frameSamplingRate + 1);
        
        base = sampledFrames(i).points';
        target = mergedFrames;
        
        [R, t] = estimateCameraPoseBetweenFrames(base, target);
        
        transformedBase = R * base + t;
        mergedFrames = mergePointClouds(transformedBase, mergedFrames);
        
        poses(i-1).rotation = R;
        poses(i-1).translation = t;
        poses(i-1).fromFrame = (i-1)*frameSamplingRate + 1;
        poses(i-1).toFrame = (i-2)*frameSamplingRate + 1;
        poses(i-1).stepSize = frameSamplingRate;
        
    end
end