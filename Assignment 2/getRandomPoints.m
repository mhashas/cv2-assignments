function [points1, points2] = getRandomPoints(p1List, p2List, numberOfPoints)
    selection =  randperm(size(p1List,2),numberOfPoints);
    points1 = p1List(:,selection);
    points2 = p2List(:,selection);
end