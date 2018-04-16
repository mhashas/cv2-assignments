function [R, t] = getTransformationParameters(base, target)
    target_mean = mean(target, 2);
    base_mean = mean(base, 2);
    
    base_new = base - repmat(base_mean, 1, size(base, 2));
    target_new = target - repmat(target_mean, 1, size(target, 2));
    
    A = base_new * target_new';
    [U, ~, V] = svd(A);
    
    R = V * U';
    t = target_mean - R * base_mean;
end