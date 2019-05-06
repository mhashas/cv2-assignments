function visualisePointCloud(pointCloud, option)
    clf
    fscatter3(pointCloud.points(1,:),pointCloud.points(2,:),pointCloud.points(3,:), pointCloud.points(3,:));
%     plot3(pointCloud.points(1,:),pointCloud.points(2,:),pointCloud.points(3,:),option);
end