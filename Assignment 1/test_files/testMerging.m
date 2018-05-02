options.sampling = struct;
options.sampling.name = "random";
options.sampling.bothFrames = 0;
options.sampling.randomPerIteration = 1;
options.sampling.isProcent = 0; % can merge isProcent and value fields in just one 'value' field
options.sampling.value = 2000;

options.noiseRemoval = 0;
options.visualiseSteps = 0;

options.stoppingCriterion = struct;
options.stoppingCriterion.epsilon = 0;
options.stoppingCriterion.noIterations = 40;


cumulatedRotation = eye(3);
cumulatedTranslation = zeros(3,1);

poses = estimateCameraPoses(frames, 4, options, 1, 30);

sampling = struct;
sampling.name = "random";
sampling.noise_removal = 0;
sampling.value = 3000;
sampling.isProcent = 0;

hold on;
plot_every = 1;
points = frames(poses(1).toFrame).points;
fscatter3(points(:,1),points(:,2),points(:,3), points(:,2));
for i=1:length(poses)
    cumulatedRotation = (poses(i).rotation) * cumulatedRotation;
    cumulatedTranslation = (poses(i).rotation) * cumulatedTranslation + (poses(i).translation);
    
    
    points = samplePoints(frames(poses(i).fromFrame), sampling);
    points = cumulatedRotation * points.points + cumulatedTranslation;

    if mod(i,plot_every) == 0
        fscatter3(points(1,:),points(2,:),points(3,:), points(3,:));
        legend(['Last frame = ',num2str(poses(i).fromFrame)],'Location','NorthEast')
        pause(1);
    end
end
hold off;