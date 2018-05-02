function [rotation, translation] = estimateCameraPoseBetweenFrames(frameOne, frameTwo, options)
% rotation, translation - This function returns a rotation and
% a translation that when applied on frameOne, it should match frameTwo.
% In other words:(rotation * frameOne) + translation approximates target frame "frameTwo"
% Note: Indeed, this function is just a wrapper around ICP algorithm.
% 
% Syntax:  [rotation, translation] = function_name(input1,input2,input3)
%
% Inputs:
%    frameOne - struct with fields {points, normals};
%    frameTwo - struct with fields {points, normals};
%    options - option struct;
%
% Outputs:
%    rotation - 3 by 3 matrix
%    translation - 3 by 1 matrix
    [rotation, translation] = ICP(frameOne, frameTwo, options);
end