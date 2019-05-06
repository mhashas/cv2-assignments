function [F, points1, points2] = getFundamentalMatrixFromImages(image1, image2, options)

    [f1, ~, f2, ~, matches, ~] = getKeypointMatches(image1, image2, options.keypointSelection.threshold);

    p1List = f1([1,2], matches(1,:));
    p2List = f2([1,2], matches(2,:));
    
    if options.keypointSelection.backgroundRemoval == 1
        [p1List, p2List] = selectPointsInForeground(image1, p1List, image2, p2List, options.keypointSelection.backgroundRemovalOption);
    end
    
    
    if options.normaliseAndRANSAC == -1
        F = cell(3,1);
        points1 = cell(3,1);
        points2 = cell(3,1);
        if nargout > 1
            [F{1}, points1{1}, points2{1}] = eightPointAlgorithm(p1List, p2List, 0);
            [F{2}, points1{2}, points2{2}] = eightPointAlgorithm(p1List, p2List, 1);
            [F{3}, points1{3}, points2{3}] = eightPointAlgorithm(p1List, p2List, 2);
        else
            F{1} = eightPointAlgorithm(p1List, p2List, 0);
            F{2} = eightPointAlgorithm(p1List, p2List, 1);
            F{3} = eightPointAlgorithm(p1List, p2List, 2);
        end
    else
        if nargout > 1
            [F, points1, points2] = eightPointAlgorithm(p1List, p2List, options.normaliseAndRANSAC);
        else
            F = eightPointAlgorithm(p1List, p2List, options.normaliseAndRANSAC);
        end
    end
end