function [idx] = getMatchingPoints(base, target)
    distances = pdist2(base', target');
    [~, idx] = min(distances, [], 2);
end