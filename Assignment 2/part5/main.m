%close all
%clear all

data = load("./../PointViewMatrix.txt");
%add zeros manually simulating dense blocks
% data(1:50,51:215) = 0;
% data(51:100,1:24) = 0;
% data(51:100,101:215) = 0;
% data(101:150,1:49) = 0;
% data(101:150,201:215) = 0;
% data(151:202,1:149) = 0;
denseBlocks = getDenseBlocks(data, 200, 3, 3);
stitchedPoints = stitchDenseBlocks(data, denseBlocks, 'oneToAll','target');
figure
plot3D(stitchedPoints, 'b.');
