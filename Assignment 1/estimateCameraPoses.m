function poses = estimateCameraPoses(frames, frameSamplingRate, sampling)
    if ~isfield(sampling, 'size')
        set_percent = 1;
    else
        set_percent = 0;
    end
    
    sampledFrames = frames(1:frameSamplingRate:end);
    for i=2:length(sampledFrames)
        fprintf("Frame number:%d\n",i);
        if set_percent == 1;
            sampling.size = floor(size(sampledFrames(i).points,1) / 10);
        end
        [poses(i-1).rotation, poses(i-1).translation] = estimateCameraPoseBetweenFrames(sampledFrames(i).points', sampledFrames(i-1).points', sampling);
        poses(i-1).fromFrame = i;
        poses(i-1).toFrame = i-1;
        poses(i-1).stepSize = frameSamplingRate;
        
    end
end