function [mask] = getMask(image, iterations)
    mask = zeros(size(image));
    mask(1:end-1,1:end-1) = 1;
    mask =  activecontour(image, mask, iterations);
end