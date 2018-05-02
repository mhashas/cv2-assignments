%% Test ICP

options.sampling = struct;
options.sampling.name = "random";
options.sampling.bothFrames = 0;
options.sampling.randomPerIteration = 1;
options.sampling.isProcent = 0; % can merge isProcent and value fields in just one 'value' field
options.sampling.value = 2000;
options.sampling.noiseRemoval = 0;

options.rejectMatches = 1;
options.visualiseSteps = 1;

options.stoppingCriterion = struct;
options.stoppingCriterion.epsilon = 0;
options.stoppingCriterion.noIterations = 40;


source = frames(83);
target = frames(85);

[R, t] = ICP(source, target, options);

source = source.points; 
target = target.points;
source = R * source + t;

figure
hold all
plot3(target(1, :), target(2, :), target(3, :), 'r.');
plot3(source(1, :), source(2, :), source(3, :), 'b.');