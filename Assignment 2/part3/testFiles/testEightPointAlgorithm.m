%% Run startup.m
startup

%% Load mock data
id = 11;
image1 = getImage(id);
id = 13;
image2 = getImage(id);
clear id

%% Get matching pairs;

[f1, ~, f2, ~, matches, ~] = getKeypointMatches(image1, image2, 3);

p1List = f1([1,2], matches(1,:));
p2List = f2([1,2], matches(2,:));
clear f1 f2 matches;

%% Run Eight-Point Algorithm

[F0, ~, ~] = eightPointAlgorithm(p1List, p2List, 0);
[F1, ~, ~] = eightPointAlgorithm(p1List, p2List, 1);
[F2, ~, ~] = eightPointAlgorithm(p1List, p2List, 2);

%% Print images and emipolar lines

showEpipolarLinesInteractiv(image1, image2, F0, F1, F2);
