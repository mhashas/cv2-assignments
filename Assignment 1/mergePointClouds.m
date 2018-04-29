function mergedCloud =  mergePointClouds(cloudOne, cloudTwo)
%mergedCloud - This function merges two point clouds( no matter the
%dimension) by taking the reunion between the two clouds
%
% Syntax:  [output1,output2] = function_name(input1,input2,input3)
%
% Inputs:
%    cloudOne - 3 by D1 matrix;
%    cloudTwo - 3 by D2 matrix
%
% Outputs:
%    mergedCloud - 3 by D3 matrix (the merged point cloud)
    mergedCloud = unique([cloudOne, cloudTwo]', 'rows')';
end