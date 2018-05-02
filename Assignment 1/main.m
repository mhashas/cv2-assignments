%% Read the data
frames = struct;
for i=0:99
    if i<10
        [frames(i+1).points, frames(i+1).normals] = getPcdMATfile(sprintf("data_mat1/000000000%d", i));
    else
        [frames(i+1).points, frames(i+1).normals] = getPcdMATfile(sprintf("data_mat1/00000000%d", i));
    end
end
clear i % remove 'i' from workspace

%% Set ICA options.
options = struct;

options.sampling = struct;
options.sampling.name = "random";
options.sampling.bothFrames = 0;
options.sampling.randomPerIteration = 0;
options.sampling.isProcent = 0; % can merge isProcent and value fields in just one 'value' field
options.sampling.value = 2000;
options.sampling.noiseRemoval = 0;

options.visualiseSteps = 0;
options.rejectMatches = 1;

options.stoppingCriterion = struct;
options.stoppingCriterion.epsilon = 0;
options.stoppingCriterion.noIterations = 40;



%% Frame by frame estimation - random
options.sampling.name = "random";

% posesEveryFrame = estimateCameraPoses(frames, 1, options);
% save('./poseEstimations/posesEveryFrame.mat','posesEveryFrame');
load('./poseEstimations/posesEveryFrame.mat');

% posesEverySecondFrame = estimateCameraPoses(frames, 2, options);
% save('./poseEstimations/posesEverySecondFrame.mat','posesEverySecondFrame');
load('./poseEstimations/posesEverySecondFrame.mat');

% posesEveryFifthFrame = estimateCameraPoses(frames, 4, options);
% save('./poseEstimations/posesEveryFifthFrame.mat','posesEveryFifthFrame');
load('./poseEstimations/posesEveryFifthFrame.mat');

% posesEveryTenthFrame = estimateCameraPoses(frames, 10, options);
% save('./poseEstimations/posesEveryTenthFrame.mat','posesEveryTenthFrame');
load('./poseEstimations/posesEveryTenthFrame.mat');

options.sampling.randomPerIteration = 1;

% RposesEveryFrame = estimateCameraPoses(frames, 1, options);
% save('./poseEstimations/RposesEveryFrame.mat','RposesEveryFrame');
load('./poseEstimations/RposesEveryFrame.mat');

% RposesEverySecondFrame = estimateCameraPoses(frames, 2, options);
% save('./poseEstimations/RposesEverySecondFrame.mat','RposesEverySecondFrame');
load('./poseEstimations/RposesEverySecondFrame.mat');

% RposesEveryFifthFrame = estimateCameraPoses(frames, 4, options);
% save('./poseEstimations/RposesEveryFifthFrame.mat','RposesEveryFifthFrame');
load('./poseEstimations/RposesEveryFifthFrame.mat');

% RposesEveryTenthFrame = estimateCameraPoses(frames, 10, options);
% save('./poseEstimations/RposesEveryTenthFrame.mat','RposesEveryTenthFrame');
load('./poseEstimations/RposesEveryTenthFrame.mat');

%% Frame by frame estimation - uniform-normals
options.sampling.name = "uniform-normals";

normalPosesEveryFrame = estimateCameraPoses(frames, 1, options);
save('./poseEstimations/normalPosesEveryFrame.mat','normalPosesEveryFrame');
load('./poseEstimations/normalPosesEveryFrame.mat');

normalPosesEverySecondFrame = estimateCameraPoses(frames, 2, options);
save('./poseEstimations/normalPosesEverySecondFrame.mat','normalPosesEverySecondFrame');
load('./poseEstimations/normalPosesEverySecondFrame.mat');

normalPosesEveryFifthFrame = estimateCameraPoses(frames, 5, options);
save('./poseEstimations/normalPosesEveryFifthFrame.mat','normalPosesEveryFifthFrame');
load('./poseEstimations/normalPosesEveryFifthFrame.mat');

normalPosesEveryTenthFrame = estimateCameraPoses(frames, 10, options);
save('./poseEstimations/normalPosesEveryTenthFrame.mat','normalPosesEveryTenthFrame');
load('./poseEstimations/normalPosesEveryTenthFrame.mat');

%% Frame by "cumulative frames" estimation

cumulativePosesEveryFrame = estimateCameraPosesIterativeMerges(frames, 1);
save('cumulativePosesEveryFrame.mat','cumulativePosesEveryFrame');
load('cumulativePosesEveryFrame.mat');

cumulativePosesEverySecondFrame = estimateCameraPosesIterativeMerges(frames, 2);
save('cumulativePosesEverySecondFrame.mat','cumulativePosesEverySecondFrame');
load('cumulativePosesEverySecondFrame.mat');

cumulativePosesEveryFifthFrame = estimateCameraPosesIterativeMerges(frames, 5, sampling,1, 21);
save('cumulativePosesEveryFifthFrame.mat','cumulativePosesEveryFifthFrame');
load('cumulativePosesEveryFifthFrame.mat');

cumulativePosesEveryTenthFrame = estimateCameraPosesIterativeMerges(frames, 10, sampling,1, 52 );
save('cumulativePosesEveryTenthFrame.mat','cumulativePosesEveryTenthFrame');
load('cumulativePosesEveryTenthFrame.mat');

%% merge frames

cumulatedRotation = eye(3);
cumulatedTranslation = zeros(3,1);

poses = RposesEveryFifthFrame;

sampling = struct;
sampling.name = "random";
sampling.value = 1000;
sampling.isProcent = 0;
sampling.noiseRemoval = 0;

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
        pause(0.4);
    end
end
hold off;