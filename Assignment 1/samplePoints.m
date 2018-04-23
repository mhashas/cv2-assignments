function sampledPoints = samplePoints(points, k, type)


    switch type
        case 'random'
            [~, noPoints] = size(points);
            randomPermutation = randperm(noPoints);
            numberOfSamples = min(k, noPoints);
            randomPermutation = randomPermutation(1:numberOfSamples);
            sampledPoints = points(:,randomPermutation);
        case 'uniform'
            k = floor(k^(1/3));
            min_x = min(points(1,:));
            max_x = max(points(1,:));
            xs = linspace(min_x, max_x, k);
            min_y = min(points(2,:));
            max_y = max(points(2,:));
            ys = linspace(min_y, max_y, k);
            min_z = min(points(3,:));
            max_z = max(points(3,:));
            zs = linspace(min_z, max_z, k);
            
%             The idea is to create a 3D grid, and to take all the points that
%             are closest to each point of the grid.

            [X,Y,Z] = meshgrid(xs,ys,zs);
            gridCloud = [X(:),Y(:),Z(:)]';
           
            [mins_distance, mins_idx] = getMatchingPoints(gridCloud, points);
            
            sampledPoints = points(:, unique(mins_idx));

        otherwise
            % random sample.
            [~, noPoints] = size(points);
            randomPermutation = randperm(noPoints);
            numberOfSamples = min(k, noPoints);
            randomPermutation = randomPermutation(1:numberOfSamples);
            sampledPoints = points(:,randomPermutation);
    end

end