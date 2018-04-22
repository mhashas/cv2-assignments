function sampledPoints = samplePoints(points, k, type)


    switch type
        case 'random'
            [~, noPoints] = size(points);
            randomPermutation = randperm(noPoints);
            numberOfSamples = min(k, noPoints);
            randomPermutation = randomPermutation(1:numberOfSamples);
            sampledPoints = points(:,randomPermutation);
        otherwise
            % random sample.
            [~, noPoints] = size(points);
            randomPermutation = randperm(noPoints);
            numberOfSamples = min(k, noPoints);
            randomPermutation = randomPermutation(1:numberOfSamples);
            sampledPoints = points(:,randomPermutation);
    end

end