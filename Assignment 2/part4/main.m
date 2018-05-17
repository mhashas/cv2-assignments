%% run startup.m

startup
    
%% 
id = 11;
image1 = getImage(id);
id = 12;
image2 = getImage(id);
clear id

pv_matrix = chaining(1,49);
imshow(pv_matrix(:, 1:1200));
plot_pv_matrix(pv_matrix(:,1:1200));