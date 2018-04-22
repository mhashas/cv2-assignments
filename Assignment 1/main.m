%% test section

source = load('./Data/source.mat');
target = load('./Data/target.mat');

[R, t] = ICP(samplePoints(frames(21).points', 1000, 'random'), frames(11).points', 20, 0);

target = frames(11).points';
source = frames(21).points';

figure
source = R * source + t;
fscatter3(target(1, :), target(2, :), target(3, :), target(3, :));
fscatter3(source(1, :), source(2, :), source(3, :), source(3, :));

%% Read the data
files = [];
for i=0:99
    if i<10
%         frames(i+1) = load(sprintf("data_mat1/000000000%d.mat", i));
        frames(i+1).points = getPcd(sprintf("Data/data/000000000%d.pcd", i));
    else
%         frames = [frames, load(sprintf("data_mat1/00000000%d.mat", i))];
        frames(i+1).points = getPcd(sprintf("Data/data/00000000%d.pcd", i));
    end
end

%% get poses
poses = estimateCameraPoses(frames, 2);

%% merge frames

cumulatedRotation = eye(3);
cumulatedTranslation = zeros(3,1);

hold all;
points = frames(poses(1).toFrame).points';
plot3(points(:,1),points(:,2),points(:,3), 'o', 'markerSize', 0.3);

 for i=1:20
     to_Frame = (poses(i).toFrame - 1) * poses(i).stepSize + 1;
     from_Frame = (poses(i).fromFrame - 1) * poses(i).stepSize + 1;
     
     cumulatedRotation = (poses(i).rotation) * cumulatedRotation;
     cumulatedTranslation = (poses(i).rotation) * cumulatedTranslation + (poses(i).translation);
     
     points = frames(from_Frame).points'; 
     points = cumulatedRotation * points + cumulatedTranslation;
     
     plot3(points(1,:),points(2,:),points(3,:), 'bo', 'markerSize', 0.3);
 end
