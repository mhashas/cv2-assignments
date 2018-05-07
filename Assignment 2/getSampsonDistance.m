function [distance] = getSampsonDistance(point1, point2, F)
    point1 = [point1(1,:); point1(2,:); ones([1, size(point1,2)])];
    point2 = [point2(1,:); point2(2,:); ones([1, size(point2,2)])];
    
    numerator = point2' * F * point1;
    donominator = sum((F * point1).^2) + sum((F * point2).^2);
    
    distance = diag(numerator ./ donominator);
end