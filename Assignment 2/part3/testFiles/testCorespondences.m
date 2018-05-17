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
threshold = 5;
[f1, ~, f2, ~, matches, ~] = getKeypointMatches(image1, image2, threshold);

p1List = f1([1,2], matches(1,:));
p2List = f2([1,2], matches(2,:));
clear f1 f2 matches threshold;

%% OPTIONAL - Get points in foreground
[p1List, p2List] = selectPointsInForeground(image1, p1List, image2, p2List);

%% Test corespondences

% p1List = p1List(:,[1:1:200]);
% p2List = p2List(:,[1:1:200]);

showCorespondences(image1, image2, p1List, p2List)
