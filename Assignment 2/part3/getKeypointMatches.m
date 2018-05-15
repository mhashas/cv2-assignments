function [f1, d1, f2, d2, matches, scores] = getKeypointMatches(img1, img2)
% getImage - This function returns sift descriptor, sift interest points
% position, matches between interest points, and scores for each match.
%
% Syntax:  [f1, d1, f2, d2, matches, scores] = getKeypointMatches(img1, img2)
%
% Inputs:
%   img1, img2 - images, as read with im2single(imread("{{path}}"));
%                             or with getImage(id);
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
    [f1,d1] = extractSIFT(img1);
    [f2,d2] = extractSIFT(img2);

    [matches, scores] = vl_ubcmatch(d1, d2);
end