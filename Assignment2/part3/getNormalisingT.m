function [T] = getNormalisingT(points)
% getNormalisingT - This function returns the normalising matrix T, as
% descriped in normalising eight point algorithm. <points'> * <T> gives
% points that have mean [0,0], and the average distance to mean is sqrt(2).
%
% Syntax:  [T] = getNormalisingT(points)
%
% Inputs:
%   points - 2 by N matrix
%                   - N represents the number of points
%                   - 2, for x and y coordonate of a point; however, this 
%                      dimension can be higher, because only the first two
%                      rows are used.
%
% Outputs:
%    T - 3 by 3 matrix
    xList = points(1,:);
    yList = points(2,:);
    mx = mean(xList, 2);

    my = mean(yList, 2);

    d = mean(sqrt((xList - mx).^2 + (yList - my).^2), 2);

    T = [sqrt(2)/d 0 -(mx*sqrt(2))/d ; 0 sqrt(2)/d -(my*sqrt(2))/d ; 0 0 1];
end