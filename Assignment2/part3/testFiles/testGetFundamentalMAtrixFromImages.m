%% Run startup.m
startup

%% Load mock data
id = 1;
image1 = getImage(id);
id = 5;
image2 = getImage(id);
clear id

%% Contruct options

options = struct;

options.keypointSelection = struct;
options.keypointSelection.threshold = 5; % default: 1.5; higher appears to be better.
options.keypointSelection.backgroundRemoval = 1; % 1 | 0
options.keypointSelection.backgroundRemovalOption = 'both';  % 'all' | 'both' | 'left' | 'right'

options.normaliseAndRANSAC = -1; % 0 | 1 | 2 | -1; '-1' returs stuctures with 3 matrices(one for each option 0, 1, 2), and 3 point-clouds per image; 

%% Run algorithm

[F, points1, points12] = getFundamentalMatrixFromImages(image1, image2, options);

%% Visualise results

if options.normaliseAndRANSAC == -1
    showEpipolarLinesInteractiv(image1, image2, F{1}, F{2}, F{3})
else
    showEpipolarLinesInteractiv(image1, image2, F)
end
