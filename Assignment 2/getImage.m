function [image] = getImage(id)
dataset_path = 'Data/House/';
image_path = '';

if id < 10
    image_path = ['frame0000000', num2str(id),'.png'];
elseif id  >= 10
    image_path = ['data/House/frame000000',  num2str(id),'.png'];
end

image = im2single(imread(strcat(dataset_path,image_path)));
end