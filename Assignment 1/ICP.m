function [rotation, translation, rms_history] = ICP(base, target, options)
% ICP - This function fonds a transformation between 'base' and 'target' parameter,
% according to the 'options' parameter
%
% Syntax:  [rotation, translation, rms_history] = ICP(base, target, options)
%
% Inputs:
%   base - struct with fields {points, normals};
%       base.points and base.normals: 3 by D matrice
%   target - struct with fields {points, normals};
%   options - struct, with the following fields:
%       options.sampling.name = 'all'|'random'|'uniform-normals'|'combined';
%       options.sampling.bothFrames = 1|0 ;
%       options.sampling.randomPerIteration = 1|0;
%       options.sampling.isProcent = 1|0; % can merge isProcent and value fields in just one 'value' field
%       options.sampling.value = float|integer;
%       options.sampling.noiseRemoval = 1|0;
% 
%       options.rejectMatches = 1|0;
%       options.visualiseSteps = 1|0;

%       options.stoppingCriterion.epsilon = float;
%       options.stoppingCriterion.noIterations = integer;
%
% Outputs:
%   rotation - 3 by 3 matrix
%   translation - 3 by 1 matrix
%   rms_history - ???  


    rms_history = [];
    past_rms = 100;
    
    % Initialize R and t
    rotation = eye(3);
    translation = zeros(3, 1);
    
    % Initial sampling of points.
    sampled_base = samplePoints(base, options.sampling);
    if options.sampling.bothFrames
        sampled_target = samplePoints(target, options.sampling);
    else
        sampled_target = target;
    end
    
    for iteration = 1:options.stoppingCriterion.noIterations
        % Select points to work with
        if options.sampling.randomPerIteration
            sampled_base = samplePoints(base, options.sampling);
            if options.sampling.bothFrames
                sampled_target = samplePoints(target, options.sampling);
            end
        end

        % Find closest points
        [mins_distance, mins_idx] = getMatchingPoints(sampled_base.points, sampled_target.points);
        
        % -------- experiemntal ---------
        if options.rejectMatches
            [~, sortedIndices] = sort(mins_distance);
            chosenIndices = sortedIndices(1:round(0.9*size(sortedIndices,1)));
            mins_idx = mins_idx(chosenIndices);
            sampled_base.points = sampled_base.points(:, chosenIndices);
            sampled_base.normals = sampled_base.normals(:, chosenIndices);
        end
        % -------- experiemntal ---------
        
        matched_target = sampled_target.points(:, mins_idx);
        
        % Refine R and t using SVD
        [R, t] = getTransformationParameters(sampled_base.points, matched_target);
        
        % Update base
        base.points = (R * base.points) + t;
        sampled_base.points = (R * sampled_base.points) + t;
        
        % Update rotation and translation
        rotation = R * rotation;
        translation = R * translation + t;   
        
        % Visualize
        rms = getRMS(sampled_base.points, matched_target);
        rms_history = [rms_history, rms];
        if options.visualiseSteps 
            visualiseProgress(base, target, rms_history); 
        end
        
        % RMS stopping criterion based on epsilon
        if abs(rms - past_rms) < options.stoppingCriterion.epsilon
            fprintf("Stopping early iteration: %d, RMS: %3.4f\n", iteration, rms);
            break
        end
        past_rms = rms;
    end                                                                         
end


function visualiseProgress(base, target, rms_history)
% rms_history should containt at least one value, and the last value should
% be the currnet rms
    subplot(6, 1, [1, 2, 3, 4])
    plot3(base.points(1, :), base.points(2, :), base.points(3, :), 'r.', target.points(1, :), target.points(2, :), target.points(3, :), 'b.');
    legend('Source', 'Target','Location','NorthEast')

    subplot(6, 1, [5, 6])
    plot(rms_history)
    xlabel('Iteration')
    ylabel('RMS')
    legend(['RMS = ',num2str(rms_history(end),'%3.5f')],'Location','NorthEast')

    pause(0.1)
end