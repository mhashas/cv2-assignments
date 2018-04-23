%% Read the data
    files = [];
    frames = struct;
    for i=0:109
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

source = frames(6).points';
target = frames(11).points';

[R, t] = ICP(samplePoints(source, 1000, 'random'), target, 40, 0);

figure
source = R * source + t;
fscatter3(target(1, :), target(2, :), target(3, :), target(3, :));
fscatter3(source(1, :), source(2, :), source(3, :), source(3, :));

%% get poses
poses = estimateCameraPosesIterativeMerges(frames, 5, 1, 20);

%% merge frames

cumulatedRotation = eye(3);
cumulatedTranslation = zeros(3,1);

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
