function [M, S, t] = factorization(pointview_data)

    % this should be applied to each dense block
    % returns [M, S, t]
    data_mean = mean(pointview_data, 2);
    data_centered = pointview_data - data_mean;
    [U,W,V] = svd(data_centered);
    U3 = U(:, 1:3);
    W3 = W(1:3, 1:3);
    V3 = V(:, 1:3);
    
    %motion
    %M = U3*sqrt(W3);
    M = U3;
    %shape
    %S = sqrt(W3)*V3';
    S = W3*V3';
    
    t = data_mean;
    
end

