%close all
%clear all

data = load("./PointViewMatrix.txt");

%% add zeros manually simulating dense blocks
% data(1:50,51:215) = 0;
% data(51:100,1:24) = 0;
% data(51:100,101:215) = 0;
% data(101:150,1:49) = 0;
% data(101:150,201:215) = 0;
% data(151:202,1:149) = 0;


%%
data(isnan(data))=0;
denseBlocks = getCommonBlocks(data, 12, 3, 8);

removeBackground = 0;
affineAmbiguity = 1;
allignMethod = "procrustes";

stitchedPoints = structureFromMotion(data, denseBlocks, 'allToOne','source', affineAmbiguity, removeBackground, allignMethod);

figure
plot3D(stitchedPoints, 'b.');
