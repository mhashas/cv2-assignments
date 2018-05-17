function [image] = getImage(id)
% getImage - This function returns the image with ge given id.
%
% Syntax:  [image] = getImage(id)
%
% Inputs:
%   id - integer bigger than 0.
%
% Outputs:
%    image - images, as read with im2single(imread("{{path}}"));
dataset_path = 'Data/House/';
image_path = '';

if id < 10
    image_path = ['frame0000000', num2str(id),'.png'];
elseif id  >= 10
    image_path = ['frame000000',  num2str(id),'.png'];
end

image = imread(strcat(dataset_path,image_path));
end