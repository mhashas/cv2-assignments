function [rotation, translation] = ICP(base, target, nr_iterations, visualize)
    % initialize R and t
    rotation = eye(3);
    translation = zeros(3, 1);
        
    for iter = 1:nr_iterations      
        % find closest points
        idx = getMatchingPoints(base, target);
        matched_target = target(:, idx);
        
        % refine R and t using SVD
        [R, t] = getTransformationParameters(base, matched_target);
        
        % update base
        base = (R * base) + t;
        
        % update rotation and translation
        rotation = R * rotation;
        translation = R * translation + t;   
        
        % visualize
        if visualize == 1
            plot3(target(1, :), target(2, :), target(3, :), 'ro', ...
                base(1, :), base(2, :), base(3, :), 'bo');
            pause(1)
        end
        
    end
                                                                                
end