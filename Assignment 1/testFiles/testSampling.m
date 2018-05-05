%% Test sampling
sampling = struct;
sampling.name = "random";
sampling.bothFrames = 0;
sampling.randomPerIteration = 0;
sampling.noiseRemoval = 0;
sampling.isProcent = 0; % can merge isProcent and value fields in just one 'value' field
sampling.value = 500;

visualisePointCloud(samplePoints(frames(1),sampling),'r.');