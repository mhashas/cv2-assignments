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
    
    % image = imgaussfilt(image,10);
    %[f, d] = vl_sift(image,'Levels',1);%'EdgeThresh',5,'PeakThresh',0.0005); 
    [f, d] = vl_sift(single(image));%,'EdgeThresh',4,'PeakThresh',0.001); 
end