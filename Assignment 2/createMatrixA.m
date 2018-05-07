function [A] = createMatrixA(x_y1, x_y2, matches)
    rearrangedF1 = x_y1(:, matches(1,:));
    xList = rearrangedF1(1,:)';
    yList = rearrangedF1(2,:)';
    
    rearrangedF2 = x_y2(:, matches(2,:));
    xPrimeList = rearrangedF2(1,:)';
    yPrimeList = rearrangedF2(2,:)';

    A = [xList.*xPrimeList,xList.*yPrimeList,xList,yList.*xPrimeList,yList.*yPrimeList,yList,xPrimeList,yPrimeList, ones(size(xList))];
end