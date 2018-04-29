function [matching_points_distance, matching_points_idx] = getMatchingPoints(base, target)
    distances = pdist2(base', target');
    
    [matching_points_distance, matching_points_idx] = min(distances, [], 2); 
end