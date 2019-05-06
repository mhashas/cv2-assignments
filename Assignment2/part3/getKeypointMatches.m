function [f1, d1, f2, d2, matches, scores] = getKeypointMatches(img1, img2, threshold)
% getImage - This function returns sift descriptor, sift interest points
% position, matches between interest points, and scores for each match.
%
% Syntax:  [f1, d1, f2, d2, matches, scores] = getKeypointMatches(img1, img2)
%
% Inputs:
%   img1, img2 - images, as read with im2single(imread("{{path}}"));
%                             or with getImage(id);
%   threshold - descriptor D1 is matched to a descriptor D2 only if the 
%           distance d(D1,D2) multiplied by 'threshold' is not greater than the 
%           distance of D1 to all other descriptors. The default value of 
%           'threshold' is 1.5.
%
% Outputs:
%    f1, f2 - Each column of F is a feature frame and has the format [X;Y;S;TH], 
%           where X,Y is the (fractional) center of the frame, S is the 
%           scale and TH is the orientation (in radians).
%    d1, d2 - Each column of D is the descriptor of the corresponding frame in 
%           f. A descriptor is a 128-dimensional vector of class UINT8.
%    matches - 2 by K, where K is the number of point pairs detected in 
%               image1 and image2. Each column contains the index of a point
%               from f1, and the index of the correspoding point from f2.
%   scores - squared Euclidean distance between the matches;

    if nargin == 2
        threshold = 1.5;
    end
    
    [f1,d1] = extractSIFT(img1);
    [f2,d2] = extractSIFT(img2);

    [matches, scores] = vl_ubcmatch(d1, d2, threshold);
end