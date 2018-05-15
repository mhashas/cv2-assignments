function [distance] = getSampsonDistance(points1, points2, F)
% getSampsonDistance - returns teh Sampson distance between two points(or
% two sets fo points), given a fundamental matrix F.
%
% Syntax:  [distance] = getSampsonDistance(point1, point2, F)
%
% Inputs:
%   points1, points2- 2 by N
%                   - N represents the number of points
%                   - 2, for x and y coordonate of a point; however, this 
%                      dimension can be higher, because only the first two
%                      rows are used.
%   F - 3 by 3 fundamental matrix;
%
% Outputs:
%    distance - Sampson distance between point1 and point2, given
%    fundamental matrix F. it can be a vector or a scalar, depending on the
%    input points.
    points1 = [points1(1,:); points1(2,:); ones([1, size(points1,2)])];
    points2 = [points2(1,:); points2(2,:); ones([1, size(points2,2)])];
    
    numerator = (points2' * F * points1).^2;
    donominator = sum((F * points1).^2) + sum((F * points2).^2);
    
    distance = diag(numerator ./ donominator);
end