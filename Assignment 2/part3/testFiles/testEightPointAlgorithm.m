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
clear f1 f2 matches;

%% Run Eight-Point Algorithm

F0 = eightPointAlgorithm(p1List, p2List, 0);
F1 = eightPointAlgorithm(p1List, p2List, 1);
F2 = eightPointAlgorithm(p1List, p2List, 2);