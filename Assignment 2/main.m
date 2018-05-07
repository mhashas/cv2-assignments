%% run startup.m

startup
    
%% 
id = 11;
image1 = getImage(id);
id = 12;
image2 = getImage(id);
clear id

F2 = eightPointAlgorithm(image1, image2, 1);
