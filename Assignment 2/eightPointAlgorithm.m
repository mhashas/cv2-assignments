function [fundamentalMatrix] = eightPointAlgorithm(image1, image2, normalise)
    if nargin == 2
        normalise = 0;
    end
    
%     Get matching pairs;
    [f1, ~, f2, ~, matches, ~] = getKeypointMatches(image1, image2);
    
    
    if normalise == 1
%         Normalise points
        T1 = getNormalisingT(f1);
        p1List = [f1(1,:); f1(2,:); ones([1, size(f1,2)])];
        p1List = T1 * p1List;
        p1List = p1List([1,2],:);
        
        T2 = getNormalisingT(f2);
        p2List = [f2(1,:); f2(2,:); ones([1, size(f2,2)])];
        p2List = T2 * p2List;
        p2List = p2List([1,2],:);
    else
%         Keep points as they are
        p1List = f1([1,2],:);
        p2List = f2([1,2],:);
    end

%     Create matrix A
    A = createMatrixA(p1List, p2List, matches);
    
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
    
    if normalise == 1
%         Denormalise fundamental matrix
        fundamentalMatrix = T2' * FMatrixEnforced * T1;
    else
%         Keep matrix as it is
        fundamentalMatrix = FMatrixEnforced;
    end
    
end