function poses = estimateCameraPoses(frames, frameSamplingRate, startFrame, endFrame)
    switch nargin
        case 4
            startFrame = startFrame;
            endFrame = endFrame;
        otherwise
            startFrame = 1;
            endFrame = length(frames);
    end
    
    sampledFrames = frames(startFrame:frameSamplingRate:endFrame);
    for i=2:length(sampledFrames)
        fprintf("Frame number:%d\n",(i-1)*frameSamplingRate + 1);
        source = sampledFrames(i).points';
        target = sampledFrames(i-1).points';
        [poses(i-1).rotation, poses(i-1).translation] = estimateCameraPoseBetweenFrames(source, target);
        poses(i-1).fromFrame = (i-1)*frameSamplingRate + 1;
        poses(i-1).toFrame = (i-2)*frameSamplingRate + 1;
        poses(i-1).stepSize = frameSamplingRate;
    end
end