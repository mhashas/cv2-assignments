function [f,d] = extractSIFT(image)
    image = single(image);
    [f, d] = vl_sift(image); 
end