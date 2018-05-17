clear all
close all
%% run startup.m
startup
    
%% 
pv_matrix = chaining(1,10);
plot_last = size(pv_matrix,2);
if size(pv_matrix,2) > 1200
    plot_last = 1200;
end
imshow(pv_matrix(:,1:plot_last));
figure
plot_pv_matrix(pv_matrix(:,1:plot_last));
%%
removeBackground = 1;
denseBlocks = getCommonBlocks(pv_matrix, 12, 3, 8);
stitchedPoints = stitchDenseBlocks(pv_matrix, denseBlocks, 'allToOne','source', removeBackground);
figure
plot3D(stitchedPoints, 'b.');