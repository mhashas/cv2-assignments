function [A] = createMatrixA(x_y1, x_y2)
% createMatrixA - This function creates the A matrix usign the x_y1 and
% x_y2 parameters, which are already matched(i.e. the point x_y1(i) matches
% the point x_y2(i) ).
%
% Syntax:  A = createMatrixA(x_y1, x_y2)
%
% Inputs:
%   x_y1, x_y2 - 2 by N matrix
%                    - N represents the number of points
%                    - 2, for x and y coordonate of a point; however, this 
%                       dimension can be higher, because only the first two
%                       rows are used.
%
% Outputs:
%    A - N by 9 matrix
    xList = x_y1(1,:)';
    yList = x_y1(2,:)';
    
    xPrimeList = x_y2(1,:)';
    yPrimeList = x_y2(2,:)';

    A = [xList.*xPrimeList,xList.*yPrimeList,xList,yList.*xPrimeList,yList.*yPrimeList,yList,xPrimeList,yPrimeList, ones(size(xList))];
end