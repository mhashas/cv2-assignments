function [fundamentalMatrix, points1, points2] = eightPointAlgorithm(p1List, p2List, normaliseAndRANSAC)
% eightPointAlgorithm - This function returns the fundamental matrix for
% some pairs of points (ideally, at least 8 pairs)
%
% Syntax:  [fundamentalMatrix] = eightPointAlgorithm(p1List, p2List, normaliseAndRANSAC)
%
% Inputs:
%   p1List, p2List  - 2 by N matrices
%                   - N represents the number of points
%                   - 2, for x and y coordonate of a point; however, this 
%                      dimension can be higher, because only the first two
%                      rows are used.
%   normaliseAndRANSAC - option for the variance of algorithm to be used
%                        0-classic eight-point algorithm
%                        1-normalised eight-point algorithm
%                        2-normalised eight-point algorithm with RANSAC
%
% Outputs:
%    fundamentalMatrix - 3 by 3 fundamental matrix.

%     Parse parameters
    if nargin == 2
        normalise = 0;
        ransac = 0;
    else
        switch  normaliseAndRANSAC
            case 0
                normalise = 0;
                ransac = 0;
            case 1
                normalise = 1;
                ransac = 0;
            case 2
                normalise = 1;
                ransac = 1;
        end
    end
    
%--------------------------Normalisation--------------------------
    if normalise == 1
%         Normalise points
        T1 = getNormalisingT(p1List);
        p1List = normalisePoints(p1List,T1);
        
        T2 = getNormalisingT(p2List);
        p2List = normalisePoints(p2List,T2);
    end
    
%--------------------Find a fundamental matrix--------------------
    if ransac == 1
        if nargout > 1
            [fundamentalMatrix, points1, points2] = getFundamentalMatrixWithRansac(p1List, p2List);
        else
            fundamentalMatrix = getFundamentalMatrixWithRansac(p1List, p2List);
        end
        
    else
        if nargout > 1
            [fundamentalMatrix, points1, points2] = getFundamentalMatrix(p1List, p2List);
        else
            fundamentalMatrix = getFundamentalMatrix(p1List, p2List);
        end
    end
    
%--------------------------Denormalisation--------------------------
    if normalise == 1
%         Denormalise fundamental matrix
        fundamentalMatrix = T2' * fundamentalMatrix * T1;
    end
    
end



function [pList] = normalisePoints(points, T)
    pList = [points(1,:); points(2,:); ones([1, size(points,2)])];
    pList = T * pList;
    pList = pList([1,2],:);
end

function [F, p1List, p2List] = getFundamentalMatrix(p1List, p2List)
    % Just for output
    if nargout > 1
        p1List = p1List;
        p2List = p2List;
    end
    
    % Create matrix A
    A = createMatrixA(p1List, p2List);
    
    % Find the SVD of A:
    [~, ~, V] = svd(A);
    
    % The entries of F are the components of the column of V corresponding
    % to the smallest singular value.
    FColumn = V(:,end);
    FMatrix = reshape(FColumn, [3,3])';
    
    % Find the SVD of F(aka FMatrix):
    [Uf, Df, Vf] = svd(FMatrix);
    
    % Set the smallest singular value in the diagonal matrix Df to zero in
    % order to obtain the corrected matrix Df prime
    Df(end,end) = 0;
    
    % Recompute F: F = Uf * (Df prime) * (Vf transpose)
    F = Uf * Df * Vf';
end

function [F, p1List, p2List] = getFundamentalMatrixWithRansac(p1List, p2List)

    manyTimes = 100; % TODO: change to a plausible value.
    threshold = 0.2; % TODO: change to a plausible value.
    maxCount = 0;
    maxMask = [];

    %Repeat this process "many times".
    for i = 1:manyTimes
        % First pick 8 point correspondences randomly from the set { pi ? p'i }
        [random8Points1, random8Points2] = getRandomPoints(p1List, p2List, 8);

        % Calculate a fundamental matrix F^.
        FCandidate = getFundamentalMatrix(random8Points1, random8Points2);

        % Count the number of inliers (the other correspondences that agree with this fundamental matrix). 
        [count, inliersMask]  = getInliers(p1List, p2List, FCandidate, threshold);

        % Pick the largest set of inliers obtained...->
        if count > maxCount
            maxCount = count;
            maxMask = inliersMask;
        end
    end

    %...-> and apply fundamental matrix estimation step to the set of all inliers.
    % Just for output
    if nargout > 1
        [F, p1List, p2List] = getFundamentalMatrix(p1List(:,find(maxMask)), p2List(:,find(maxMask)));
    else
        F = getFundamentalMatrix(p1List(:,find(maxMask)), p2List(:,find(maxMask)));
    end

end

function [count, inliersMask] = getInliers(p1List, p2List, F, threshold)
    distances = getSampsonDistance(p1List, p2List, F);
    inliersMask = distances <= threshold;
    count = sum(inliersMask);
end
