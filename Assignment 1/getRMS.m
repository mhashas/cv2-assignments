function [RMS] = getRMS(base, target)
    RMS = sum(power((base - target), 2));
    RMS = sqrt(mean(RMS));
end