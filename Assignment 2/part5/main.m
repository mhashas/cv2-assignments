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


%%
%data = load('gabriele.txt', '-ASCII');
%data(isnan(data))=0;

load('treshold-0.01.mat');
data = pv_matrix;
denseBlocks = getCommonBlocks(data, 300, 3, 5);
%denseBlocks = getDenseBlocks(data, 300, 3, 2);
stitchedPoints = stitchDenseBlocks(data, denseBlocks, 'oneToAll','source');
figure
plot3D(stitchedPoints, 'b.');
