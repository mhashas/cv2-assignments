function [points1, points2] = getRandomPoints(p1List, p2List, numberOfPoints)
% getRandomPoints - returns a number of random pairs of points from the
% provided points(note: the pairing between the two point clouds is kept)
%
% Syntax:  [points1, points2] = getRandomPoints(p1List, p2List, numberOfPoints)
%
% Inputs:
%   p1List, p2List, - 2 by N matrices
%                   - N represents the number of points
%                   - 2, for x and y coordonate of a point; however, this 
%                      dimension can be higher, because only the first two
%                      rows are used.
%   numberOfPoints - number of random pairs.
%
% Outputs:
%    points1, points2 - points sampled from input points.
    selection =  randperm(size(p1List,2),numberOfPoints);
    points1 = p1List(:,selection);
    points2 = p2List(:,selection);
end