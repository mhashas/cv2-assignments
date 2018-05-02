function poses = estimateCameraPoses(frames, frameSamplingRate, options, startFrame, endFrame)
    switch nargin
        case 5
            startFrame = startFrame;
            endFrame = endFrame;
        otherwise
            startFrame = 1;
            endFrame = length(frames);
    end

    sampledFrames = frames(startFrame:frameSamplingRate:endFrame);

    for i=2:length(sampledFrames)
        fprintf("Frame number:%d\n",(i-1) * frameSamplingRate + 1);
        [poses(i-1).rotation, poses(i-1).translation] = estimateCameraPoseBetweenFrames(sampledFrames(i), sampledFrames(i-1), options);
        poses(i-1).fromFrame = (i-1) * frameSamplingRate + 1;
        poses(i-1).toFrame = (i-2) * frameSamplingRate + 1;
        poses(i-1).stepSize = frameSamplingRate;
    end
end