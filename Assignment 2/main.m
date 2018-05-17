%% run startup.m
startup
    
%% 
pv_matrix = chaining(1,48);
imshow(pv_matrix);% (:,1:1200));
plot_pv_matrix(pv_matrix());%(:,1:1200));

%%
removeBackground = 1;
denseBlocks = getCommonBlocks(data, 12, 3, 8);
stitchedPoints = stitchDenseBlocks(data, denseBlocks, 'allToOne','source', removeBackground);
figure
plot3D(stitchedPoints, 'b.');