function poses = estimateCameraPoses(frames, frameSamplingRate, sampling, startFrame, endFrame)
    switch nargin
        case 5
            startFrame = startFrame;
            endFrame = endFrame;
        otherwise
            startFrame = 1;
            endFrame = length(frames);
    end
    
    sampledFrames = frames(startFrame:frameSamplingRate:endFrame);
 
    if ~isfield(sampling, 'size')
        set_percent = 1;
    else
        set_percent = 0;
    end
    
    for i=2:length(sampledFrames)
        fprintf("Frame number:%d\n",(i-1) * frameSamplingRate + 1);
        if set_percent == 1
            sampling.size = floor(size(sampledFrames(i).points,1) / 10);
        end
        sampling.normals = struct;
        sampling.normals.source = sampledFrames(i).normals';
        sampling.normals.target = sampledFrames(i-1).normals';
        [poses(i-1).rotation, poses(i-1).translation] = estimateCameraPoseBetweenFrames(sampledFrames(i).points', sampledFrames(i-1).points', sampling);
        poses(i-1).fromFrame = (i-1) * frameSamplingRate + 1;
        poses(i-1).toFrame = (i-2) * frameSamplingRate + 1;
        poses(i-1).stepSize = frameSamplingRate;
    end
end