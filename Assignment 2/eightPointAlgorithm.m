function [fundamentalMatrix] = eightPointAlgorithm(p1List, p2List, normaliseAndRANSAC)
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
        FMatrixEnforced = getFundamentalMatrixWithRansac(p1List, p2List);
    else
        FMatrixEnforced = getFundamentalMatrix(p1List, p2List);
    end
    
%--------------------------Denormalisation--------------------------
    if normalise == 1
%         Denormalise fundamental matrix
        fundamentalMatrix = T2' * FMatrixEnforced * T1;
    else
%         Keep matrix as it is
        fundamentalMatrix = FMatrixEnforced;
    end
    
end



function [pList] = normalisePoints(points, T)
    pList = [points(1,:); points(2,:); ones([1, size(points,2)])];
    pList = T * pList;
    pList = pList([1,2],:);
end

function [FMatrixEnforced] = getFundamentalMatrix(p1List, p2List)
%     Create matrix A
    A = createMatrixA(p1List, p2List);
    
%     Find the SVD of A:
    [~, ~, V] = svd(A);
    
%     The entries of F are the components of the column of V corresponding
%     to the smallest singular value.
    FColumn = V(:,end);
    FMatrix = reshape(FColumn, [3,3])';
    
%     Find the SVD of F(aka FMatrix):
    [Uf, Df, Vf] = svd(FMatrix);
    
%     Set the smallest singular value in the diagonal matrix Df to zero in
%     order to obtain the corrected matrix Df prime
    Df(end,end) = 0;
    
%     Recompute F: F = Uf * (Df prime) * (Vf transpose)
    FMatrixEnforced = Uf * Df * Vf';
end

function [FMatrixEnforced] = getFundamentalMatrixWithRansac(p1List, p2List)
%     TODO: implement this.
end