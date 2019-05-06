function [M, S, t] = factorization(pointViewMatrix, affineAmbiguity)
% factorization - This function returns factorization of the
% pointViewMatrix into two matrices after substracting mean
%
% Inputs:
%   pointViewMatrix -  2M * N  matrix, where M is the number of views and N is the 
%                     number of 3D points. The format is:
% 
%                     x1(1)  x2(1)   x3(1) ... xN(1)
%                     y1(1)  y2(1)  y3(1) ... yN(1)
%                     ...
%                     x1(M)  x2(M)   x3(M) ... xN(M)
%                     y1(M)  y2(M)  y3(M) ... yN(M)
%                     where xi(j) and yi(j) are the x- and y- projections of the ith 3D point 
%                     in the jth camera. 
%   affineAmbiguity - if 1, imposes uclidean constraint on the basis vectors of M
% Outputs:
%    M - N * 3 matrix, from the factorization
%    S - 3 * M matrix, from the factorization 
%    t - 1 * N matrix, mean of the pointViewMatrix by views
    
    %center data
    
    dataMean = mean(pointViewMatrix, 2);
    dataCentered = pointViewMatrix - dataMean;
    
    %get SVD decomposition
    [U,W,V] = svd(dataCentered);
    
    %impose rank 3
    U3 = U(:, 1:3);
    W3 = W(1:3, 1:3);
    V3 = V(:, 1:3);
    
    %motion
    %M = U3*sqrt(W3);
    M = U3;
    
    %shape
    %S = sqrt(W3)*V3';
    S = W3*V3';
    
    if affineAmbiguity == 1
        %impose euclidean constraints on the basis vectors in M
        MInv = pinv(M);
        L = M\MInv';
        L = L';
        C = chol(L,'lower');
        M = M*C;
        S = inv(C)*S;
    end
    
    t = dataMean;
    
end

