%% Read the data
frames = struct;
for i=0:99
    if i<10
        [frames(i+1).points, frames(i+1).normals] = getPcdMATfile(sprintf("data_mat1/000000000%d", i));
    else
        [frames(i+1).points, frames(i+1).normals] = getPcdMATfile(sprintf("data_mat1/00000000%d", i));
    end
end

%%
sampling = struct;
sampling.name = "informative";
sampling.noise_removal = 0;
sampling.size = 1000;

%% test section
source = load('./Data/source.mat');
source = source.source;
target = load('./Data/target.mat');
target = target.target;

sampling = struct;
sampling.name = "random";
sampling.noise_removal = 0;
sampling.size = 1000;

[R, t] = ICP(source, target, 40, sampling, 0, 0);

figure
source = R * source + t;
fscatter3(target(1, :), target(2, :), target(3, :), target(3, :));
fscatter3(source(1, :), source(2, :), source(3, :), source(3, :));

%% Frame by frame estimation

normalPosesEveryFrame = estimateCameraPoses(frames, 1, sampling);
save('normalPosesEveryFrame.mat','normalPosesEveryFrame');
load('normalPosesEveryFrame.mat');

normalPosesEverySecondFrame = estimateCameraPoses(frames, 2, sampling);
save('normalPosesEverySecondFrame.mat','normalPosesEverySecondFrame');
load('normalPosesEverySecondFrame.mat');

normalPosesEveryFifthFrame = estimateCameraPoses(frames, 5, sampling);
save('normalPosesEveryFifthFrame.mat','normalPosesEveryFifthFrame');
load('normalPosesEveryFifthFrame.mat');

normalPosesEveryTenthFrame = estimateCameraPoses(frames, 10, sampling);
save('normalPosesEveryTenthFrame.mat','normalPosesEveryTenthFrame');
load('normalPosesEveryTenthFrame.mat');

%% Frame by "cumulative frames" estimation

% cumulativePosesEveryFrame = estimateCameraPosesIterativeMerges(frames, 1);
% save('cumulativePosesEveryFrame.mat','cumulativePosesEveryFrame');
% load('cumulativePosesEveryFrame.mat');

% cumulativePosesEverySecondFrame = estimateCameraPosesIterativeMerges(frames, 2);
% save('cumulativePosesEverySecondFrame.mat','cumulativePosesEverySecondFrame');
% load('cumulativePosesEverySecondFrame.mat');

cumulativePosesEveryFifthFrame = estimateCameraPosesIterativeMerges(frames, 5, sampling,1, 21);
save('cumulativePosesEveryFifthFrame.mat','cumulativePosesEveryFifthFrame');
load('cumulativePosesEveryFifthFrame.mat');

cumulativePosesEveryTenthFrame = estimateCameraPosesIterativeMerges(frames, 10, sampling,1, 52 );
save('cumulativePosesEveryTenthFrame.mat','cumulativePosesEveryTenthFrame');
load('cumulativePosesEveryTenthFrame.mat');

%%
firstHalf = frames(1:50);
secondHalf = [frames(51:100),frames(1)];
reversedSecondHalf = fliplr(secondHalf);

% firstHalfPoses = estimateCameraPoses(firstHalf, 5);
% save('firstHalfPoses.mat','firstHalfPoses');
load('firstHalfPoses.mat');
secondHalfPoses = estimateCameraPoses(reversedSecondHalf, 5);
save('secondHalfPoses.mat','secondHalfPoses');
load('secondHalfPoses.mat');

%%

hold all;
plot_every = 1;
%plot the first half:
cumulatedRotation = eye(3);
cumulatedTranslation = zeros(3,1);
points = firstHalf(firstHalfPoses(1).toFrame).points';
fscatter3(points(:,1),points(:,2),points(:,3), points(:,2));
for i=1:length(firstHalfPoses)
    cumulatedRotation = (firstHalfPoses(i).rotation) * cumulatedRotation;
    cumulatedTranslation = (firstHalfPoses(i).rotation) * cumulatedTranslation + (firstHalfPoses(i).translation);
     
    points = firstHalf(firstHalfPoses(i).fromFrame).points'; 
    points = cumulatedRotation * points + cumulatedTranslation;
     
    if mod(i,plot_every) == 0
        fscatter3(points(1,:),points(2,:),points(3,:), points(3,:));
    end
end

% plot the reversed second half:
cumulatedRotation = eye(3);
cumulatedTranslation = zeros(3,1);

fscatter3(points(:,1),points(:,2),points(:,3), points(:,2));
for i=1:length(secondHalfPoses)
    cumulatedRotation = (secondHalfPoses(i).rotation) * cumulatedRotation;
    cumulatedTranslation = (secondHalfPoses(i).rotation) * cumulatedTranslation + (secondHalfPoses(i).translation);
     
    points = reversedSecondHalf(secondHalfPoses(i).fromFrame).points'; 
    points = cumulatedRotation * points + cumulatedTranslation;
     
    if mod(i,plot_every) == 0
        fscatter3(points(1,:),points(2,:),points(3,:), points(3,:));
    end
end

%% merge frames

cumulatedRotation = eye(3);
cumulatedTranslation = zeros(3,1);

poses = cumulativePosesEveryFifthFrame;

sampling = struct;
sampling.name = "random";
sampling.noise_removal = 0;
sampling.size = 3000;

hold on;
plot_every = 1;
points = frames(poses(1).toFrame).points';
fscatter3(points(:,1),points(:,2),points(:,3), points(:,2));
for i=1:length(poses)
    cumulatedRotation = (poses(i).rotation) * cumulatedRotation;
    cumulatedTranslation = (poses(i).rotation) * cumulatedTranslation + (poses(i).translation);
     
    points = frames(poses(i).fromFrame).points'; 
    points = cumulatedRotation * points + cumulatedTranslation;
     
    points = samplePoints(points, sampling);
    if mod(i,plot_every) == 0
        fscatter3(points(1,:),points(2,:),points(3,:), points(3,:));
    end
end
hold off;