function [rotation, translation, rms_history] = ICP(base, target, nr_iterations, sampling, epsilon, visualize)
    % check if visualize and epsilon were given and if not set them to
    % default
    nr_arguments = 6;
    if nargin == nr_arguments - 1
        visualize = 0;
    elseif nargin == nr_arguments - 2
        epsilon = 0;
        visualize = 0; 
    end
    
    if sampling.noise_removal == 1
        sampling.target = target;
    end
    if sampling.name ~= "random per iteration"
        sampled_points = samplePoints(base, sampling); 
    end
    
    rms_history = [];
    
    % initialize R and t
    rotation = eye(3);
    translation = zeros(3, 1);
    
    past_rms = 100;
    for iter = 1:nr_iterations   
        if sampling.name == "random per iteration"
            sampled_points = samplePoints(base, sampling); 
        end
        % find closest points
        [~, mins_idx] = getMatchingPoints(sampled_points, target);
        
        matched_target = target(:, mins_idx);
        
        % refine R and t using SVD
        [R, t] = getTransformationParameters(sampled_points, matched_target);
        
        % update base
        base = (R * base) + t;
        sampled_points = (R * sampled_points) + t;
        
        % update rotation and translation
        rotation = R * rotation;
        translation = R * translation + t;   
        
        % visualize
        %RMS stopping criterion based on epsilon
        rms = getRMS(sampled_points, matched_target);
        rms_history = [rms_history, rms];
        if visualize == 1n
            plot3(target(1, :), target(2, :), target(3, :), 'ro', ...
                base(1, :), base(2, :), base(3, :), 'bo');
            pause(0.1)
            fprintf("RMS %3.4f\n", rms);
        end
        
        % stopping criterion.
        if abs(rms - past_rms) < epsilon
            fprintf("stopping early Iteration: %d, RMS: %3.4f\n", iter, rms);
            break
        end
        past_rms = rms;
        
    end
                                                                                
end