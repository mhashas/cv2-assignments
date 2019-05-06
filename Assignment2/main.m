clear all
close all
%% run startup.m
startup
    
%% GET PVM
threshold = 10;
pv_matrix = chaining(1,49,threshold);
plot_last = size(pv_matrix,2);
if size(pv_matrix,2) > 1500
    plot_last = 1200;
end
plot_pv_matrix(pv_matrix);
figure
imshow(pv_matrix(:,1:plot_last));
%% RUN SFM
removeBackground = 1;
affineAmbiguity = 1;
denseBlocks = getCommonBlocks(pv_matrix, 100, 20, 8);
stitchedPoints = stitchDenseBlocks(pv_matrix, denseBlocks, 'allToOne','source', affineAmbiguity, removeBackground);
figure
plot3D(stitchedPoints, 'b.');