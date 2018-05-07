function [A] = createMatrixA(x_y1, x_y2)
    xList = x_y1(1,:)';
    yList = x_y1(2,:)';
    
    xPrimeList = x_y2(1,:)';
    yPrimeList = x_y2(2,:)';

    A = [xList.*xPrimeList,xList.*yPrimeList,xList,yList.*xPrimeList,yList.*yPrimeList,yList,xPrimeList,yPrimeList, ones(size(xList))];
end