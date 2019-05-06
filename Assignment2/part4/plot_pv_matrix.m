function plot_pv_matrix(pv_matrix)
% plot_pv_matrix - plots the points in the pv matrix over the image as red
% dots
%
% Syntax: plot_pv_matrix(pv_matrix)
%
% Inputs:
%   pv_matrix -  2M * N  matrix, where M is the number of views and N is the 
%                     number of 3D points. The format is:
% 
%                     x1(1)  x2(1)   x3(1) ... xN(1)
%                     y1(1)  y2(1)  y3(1) ... yN(1)
%                     ...
%                     x1(M)  x2(M)   x3(M) ... xN(M)
%                     y1(M)  y2(M)  y3(M) ... yN(M)
%                     where xi(j) and yi(j) are the x- and y- projections of the ith 3D point
%                   
% 
    image = getImage(1);
    imshow(image);
    hold all
    for row_index = 1:2:size(pv_matrix,1)-1
        plot(pv_matrix(row_index,:),pv_matrix(row_index+1,:),'r*')
    end  
end