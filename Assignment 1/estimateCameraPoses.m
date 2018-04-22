function poses = estimateCameraPoses(frames, frameSamplingRate)
    sampledFrames = frames(1:frameSamplingRate:end);
    for i=2:length(sampledFrames)
        fprintf("Frame number:%d\n",i);
        [poses(i-1).rotation, poses(i-1).translation] = estimateCameraPoseBetweenFrames(sampledFrames(i).points', sampledFrames(i-1).points');
        poses(i-1).fromFrame = i;
        poses(i-1).toFrame = i-1;
        poses(i-1).stepSize = frameSamplingRate;
        
    end
end