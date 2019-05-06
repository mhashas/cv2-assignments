function mergedCloud =  mergePointClouds(cloudOne, cloudTwo)
% mergePointClouds - This function merges two point clouds( no matter the
% dimension) by taking the reunion between the two clouds
%
% Syntax:  mergedCloud = mergePointClouds(cloudOne, cloudTwo)
%
% Inputs:
%    cloudOne - struct with fields {points, normals};
%    cloudTwo - struct with fields {points, normals};
%
% Outputs:
%    mergedCloud - struct with fields {points, normals};
%           mergedCloud.points - 3 by D3 matrix (the merged point cloud);
%           mergedCloud.normals - 3 by D3 matrix (the merged point cloud);

    A_P = [cloudOne.points, cloudTwo.points];
    A_N = [cloudOne.normals, cloudTwo.normals];
    [C, ia, ~] = unique(A_P', 'rows');
    
    mergedCloud = struct;
    mergedCloud.points = C';
    mergedCloud.normals = A_N(:,ia);
end