%% Read the data
    files = [];
    frames = struct;
    for i=0:99
        if i<10
    %         frames(i+1) = load(sprintf("data_mat1/000000000%d.mat", i));
    %         frames(i+1).points = getPcd(sprintf("Data/data/000000000%d.pcd", i));
            frames(i+1).points = getPcdMATfile(sprintf("data_mat1/000000000%d.mat", i));
            %frames(i+1).points = getPcdMATfile(sprintf("data_mat1/000000000%d_normal.mat", i));
        elseif i < 100
    %         frames = [frames, load(sprintf("data_mat1/00000000%d.mat", i))];
    %         frames(i+1).points = getPcd(sprintf("Data/data/000000000%d.pcd", i));
            frames(i+1).points = getPcdMATfile(sprintf("data_mat1/00000000%d.mat", i));
            %frames(i+1).points = getPcdMATfile(sprintf("data_mat1/00000000%d_normal.mat", i));
        else % to put the first points at the back of le list of frames.
            frames(i+1).points = getPcdMATfile(sprintf("data_mat1/000000000%d.mat", i-100));
        end
    end
        
%% test section

source = load('./Data/source.mat');
target = load('./Data/target.mat');

source = frames(1).points';
target = frames(11).points';

[R, t] = ICP(samplePoints(source, 1000, 'random'), target, 40, 0);

figure
source = R * source + t;
fscatter3(target(1, :), target(2, :), target(3, :), target(3, :));
fscatter3(source(1, :), source(2, :), source(3, :), source(3, :));

%% get poses

% % Frame by frame estimation
% posesEveryFrame = estimateCameraPoses(frames, 1);
% save('posesEveryFrame.mat','posesEveryFrame');
load('posesEveryFrame.mat');

% posesEverySecondFrame = estimateCameraPoses(frames, 2);
% save('posesEverySecondFrame.mat','posesEverySecondFrame');
load('posesEverySecondFrame.mat');

% posesEveryFifthFrame = estimateCameraPoses(frames, 5);
% save('posesEveryFifthFrame.mat','posesEveryFifthFrame');
load('posesEveryFifthFrame.mat');

% posesEveryTenthFrame = estimateCameraPoses(frames, 10);
% save('posesEveryTenthFrame.mat','posesEveryTenthFrame');
load('posesEveryTenthFrame.mat');

% Frame by "cumulative frames" estimation
% cumulativePosesEveryFrame = estimateCameraPosesIterativeMerges(frames, 1);
% save('cumulativePosesEveryFrame.mat','cumulativePosesEveryFrame');


% cumulativePosesEverySecondFrame = estimateCameraPosesIterativeMerges(frames, 2);
% save('cumulativePosesEverySecondFrame.mat','cumulativePosesEverySecondFrame');


% cumulativePosesEveryFifthFrame = estimateCameraPosesIterativeMerges(frames, 5);
% save('cumulativePosesEveryFifthFrame.mat','cumulativePosesEveryFifthFrame');
load('cumulativePosesEveryFifthFrame.mat');

% cumulativePosesEveryTenthFrame = estimateCameraPosesIterativeMerges(frames, 10);
% save('cumulativePosesEveryTenthFrame.mat','cumulativePosesEveryTenthFrame');
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

%%
source = frames(50).points';
fscatter3(source(1, :), source(2, :), source(3, :), source(3, :));

%% merge frames

cumulatedRotation = eye(3);
cumulatedTranslation = zeros(3,1);

poses = posesEveryFifthFrame;

hold all;
plot_every = 1;
points = frames(poses(1).toFrame).points';
%plot3(points(:,1),points(:,2),points(:,3), 'o', 'markerSize', 0.3);
fscatter3(points(:,1),points(:,2),points(:,3), points(:,2));
for i=1:length(poses)
    cumulatedRotation = (poses(i).rotation) * cumulatedRotation;
    cumulatedTranslation = (poses(i).rotation) * cumulatedTranslation + (poses(i).translation);
     
    points = frames(poses(i).fromFrame).points'; 
    points = cumulatedRotation * points + cumulatedTranslation;
     
    if mod(i,plot_every) == 0

%          plot3(points(1,:),points(2,:),points(3,:), 'bo', 'markerSize', 0.3);
        fscatter3(points(1,:),points(2,:),points(3,:), points(3,:));
    end
end
