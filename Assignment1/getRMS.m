function [RMS] = getRMS(base, target)
    RMS = sqrt(sum(power((base - target), 2)));
    RMS = mean(RMS);
end