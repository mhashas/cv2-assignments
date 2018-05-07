%% run startup.m
startup

%% load mock data
id = 11;
image1 = getImage(id);
id = 12;
image2 = getImage(id);
clear id

%%     Get matching pairs;

[f1, ~, f2, ~, matches, ~] = getKeypointMatches(image1, image2);

p1List = f1([1,2], matches(1,:));
p2List = f2([1,2], matches(2,:));

%% Run Eight-Point Algorithm

F0 = eightPointAlgorithm(image1, image2, 0);
F1 = eightPointAlgorithm(image1, image2, 1);
F2 = eightPointAlgorithm(image1, image2, 2);