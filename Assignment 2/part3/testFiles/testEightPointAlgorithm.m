%% Run startup.m
startup

%% Load mock data
id = 11;
image1 = getImage(id);
id = 30;
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

[F0, ~, ~] = eightPointAlgorithm(p1List, p2List, 0);
[F1, ~, ~] = eightPointAlgorithm(p1List, p2List, 1);
[F2, ~, ~] = eightPointAlgorithm(p1List, p2List, 2);

%% Print images and emipolar lines

showEpipolarLinesInteractiv(image1, image2, F0);
