function [f,d] = extractSIFT(image)
% createMatrixA - This function extracts the SIFT descriptor of an image.
%
% Syntax:  [f,d] = extractSIFT(image)
%
% Inputs:
%   image - image as read with im2single(imread("{{path}}"))
%
% Outputs:
%    f - Each column of F is a feature frame and has the format [X;Y;S;TH], 
%           where X,Y is the (fractional) center of the frame, S is the 
%           scale and TH is the orientation (in radians).
%    d -  Each column of D is the descriptor of the corresponding frame in 
%           f. A descriptor is a 128-dimensional vector of class UINT8.
    image = single(image);
    [f, d] = vl_sift(image); 
end