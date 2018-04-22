%% test section

source = load('./Data/source.mat');
target = load('./Data/target.mat');

[R, t] = ICP(source.source, target.target, 40, 0);

target = target.target;
source = source.source;

figure
source = R * source + t;
plot3(target(1, :), target(2, :), target(3, :), 'ro', source(1, :), source(2, :), source(3, :), 'bo');

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
poses = estimateCameraPoses(frames, 10);

%% merge frames

cumulatedRotation = eye(3);
cumulatedTranslation = zeros(3,1);
% 
% cumulatedRotation = (poses(1).rotation) * cumulatedRotation;
% cumulatedTranslation = (poses(1).rotation) * cumulatedTranslation + (poses(1).translation);
% 
% hold all;
% 
% points = frames(1).points;
% fscatter3(points(:,1),points(:,2),points(:,3), points(:,3));
% 
% 
% points = frames(50).points;
% 
% points = cumulatedRotation * points' + cumulatedTranslation;
% fscatter3(points(:,1),points(:,2),points(:,3), points(:,3));

hold all;
points = frames(poses(1).toFrame).points';
fscatter3(points(:,1),points(:,2),points(:,3), points(:,3));

 for i=1:2
     
     to_Frame = poses(1).toFrame * poses(1).stepSize;
     from_Frame = poses(i).fromFrame * poses(1).stepSize;
     
     cumulatedRotation = (poses(i).rotation) * cumulatedRotation;
     cumulatedTranslation = (poses(i).rotation) * cumulatedTranslation + (poses(i).translation);
     
     points = frames(from_Frame).points';
     
%      points = cumulatedRotation * points + cumulatedTranslation;
     fscatter3(points(1,:),points(2,:),points(3,:), points(3,:));
 end
