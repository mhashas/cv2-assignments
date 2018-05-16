function showCorespondences(img1,img2, points1, points2)
% showCorespondences - displays the two images side-by-side, with line
% uniting the pairs of points from the two images, for a better
% visualisation of the corespondences.
%
% Syntax:  showCorespondences(img1,img2, points1, points2)
%
% Inputs:
%   img1, img2 - grayscale/rbg images.
%   points1, points2 - 2 by N matrices:
%                       - N represents the number of points
%                       - 2, for x and y coordonate of a point; however, 
%                           this dimension can be higher, because only the 
%                           first two rows are used.

    [~,w,~] = size(img1);
    
    
    figure
    imshow([img1, img2])
    hold on
    
    x1 = points1(1,:);
    y1 = points1(2,:);
    x2 = points2(1,:);
    y2 = points2(2,:);
    
    scatter(x1,y1,'filled', 'MarkerFaceColor', 'g')
    scatter(x2+w,y2,'filled', 'MarkerFaceColor', 'g')
    colours = ['r', 'g', 'b', 'c', 'm', 'y', 'k', 'w'];
    for i = 1:max(size(x1,1),size(x1,2))
        col = colours(mod(i,length(colours))+1);
        plot([x1(i) x2(i)+w], [y1(i) y2(i)], col, 'LineWidth', 1.5);
    end
    hold off
end