%% Run startup.m
startup

%% Load mock data
id = 1;
image1 = getImage(id);
id = 5;
image2 = getImage(id);
clear id

%% Get matching pairs;

% threshold used for matching points
threshold = 3;
[f1, ~, f2, ~, matches, ~] = getKeypointMatches(image1, image2, threshold);

p1List = f1([1,2], matches(1,:));
p2List = f2([1,2], matches(2,:));
clear f1 f2 matches threshold;

%% OPTIONAL - Get points in foreground
[p1List, p2List] = selectPointsInForeground(image1, p1List, image2, p2List, 'both');

%% Run Eight-Point Algorithm

[F0, p01, p02] = eightPointAlgorithm(p1List, p2List, 0);
[F1, p11, p12] = eightPointAlgorithm(p1List, p2List, 1);
[F2, p21, p22] = eightPointAlgorithm(p1List, p2List, 2);

%% Print images and epipolar lines

showEpipolarLinesInteractiv(image1, image2, F2);

% if you want to see wich points were used for RANSAC(i.e. the inliers)
% showCorespondences(image1,image2,p21,p22);
