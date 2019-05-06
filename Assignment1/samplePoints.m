function sampledPoints = samplePoints(points, samplingOptions)
% samplePoints - This function sample points from the 'points' parameter,
% according to the 'samplingOptions' parameter
%
% Syntax:  sampledPoints = samplePoints(points, samplingOptions)
%
% Inputs:
%   points - struct with fields {points, normals};
%   samplingOptions - struct with fields:
%           samplingOptions.name = 'all'|'random'|'uniform-normals'
%           samplingOptions.value = size of sample
%           samplingOptions.isProcent = 0 | 1}
%
% Outputs:
%    sampledPoints - struct with fields {points, normals};

    if samplingOptions.noiseRemoval == 1
          % Takes to much to compute.
          % I am trying to see how far the closest neighbour is for every
          % point, and remove all the points who are the farthest from the
          % next neighbout.
          % The plots and the 'bad' variable are used to visualise the
          % points I am rejectong.
%         [distances, ~] = pdist2(points.points',points.points','euclidean','Smallest',2);
%         distances = distances(2,:);
%         [~, sortedIndices] = sort(distances);
%         bad = sortedIndices(round(0.99*size(distances,2)):end);
%         sortedIndices = sortedIndices(1:round(0.99*size(distances,2)));
%         
%         badPoints = points.points(:, bad);
%         
%         points.points = points.points(:, sortedIndices);
%         points.normals = points.normals(:,sortedIndices);
%         figure
%         hold on
%         plot3(badPoints(1,:),badPoints(2,:),badPoints(3,:),'ro');
%         plot3(points.points(1,:),points.points(2,:),points.points(3,:),'b.');
%         hold off
    end
    
    switch samplingOptions.name
        case 'all'
            sampledPoints = points;
        case 'random'
            sampledPoints = randomSample(points, samplingOptions);
        case 'uniform-normals'
            sampledPoints = uniformNormalsSample(points, samplingOptions);
        case 'combined'
            sampledPoints = combinedSample(points, samplingOptions);
        otherwise
            throw(MException('Bad sampler name', 'Bad sampler name'));
    end
    
end

function sampledPoints =  randomSample(points, samplingOptions)
    [~, noPoints] = size(points.points);
    if samplingOptions.isProcent
        numberOfSamples = round(noPoints * samplingOptions.value);
    else
        numberOfSamples = samplingOptions.value;
    end
    numberOfSamples = min(numberOfSamples, noPoints);
    randomPermutation = randperm(noPoints);
    randomPermutation = randomPermutation(1:numberOfSamples);
    sampledPoints = struct;
    sampledPoints.points = points.points(:,randomPermutation);
    sampledPoints.normals = points.normals(:,randomPermutation);
end

function sampledPoints = uniformNormalsSample(points, samplingOptions)
    [dims, noPoints] = size(points.points);
    if samplingOptions.isProcent
        numberOfSamples = round(noPoints * samplingOptions.value);
    else
        numberOfSamples = samplingOptions.value;
    end
    numberOfSamples = min(numberOfSamples, noPoints);

    sampled_indexes = zeros(1, ceil(numberOfSamples/3));
    index_in_sampled_indexes = 1;
    for i = 1:dims
        % e.g. 101 edges for 100 bins
        edges = [min(points.normals(i,:)):2/ceil(numberOfSamples/3):max(points.normals(i,:))];

        %CHECK HERE IF INDEXES OF NANS ARE THROWN, IF SO WE NEED TO
        %MAKE UP FOR THAT

        %divide into the number of points we are looking for
        [N, edges, bins] = histcounts(points.normals(i,:),edges);

        %take one from each bucket
        %visited array
        visited_array = zeros(1, ceil(numberOfSamples/3));
        indexes = 1:1:length(bins);
        random_indexes = indexes(randperm(length(indexes)));
        for idx = random_indexes
            bin = bins(idx);
            if bin > 0 && visited_array(bin) == 0
                visited_array(bin) = 1;
                sampled_indexes(index_in_sampled_indexes) = idx;
                index_in_sampled_indexes = index_in_sampled_indexes + 1;
            end
        end
    end
    sampled_indexes = unique(sampled_indexes);
    %remove 0
    sampled_indexes = sampled_indexes(2:length(sampled_indexes));

    sampledPoints = struct;
    sampledPoints.points = points.points(:, sampled_indexes);
    sampledPoints.normals = points.normals(:, sampled_indexes);
end

function sampledPoints = combinedSample(points, samplingOptions)
%   This method of sampling is a combination of uniform-normals and random
%   sampling. Aprox 60% from random sampling and aprox 40% from uniform
%   sampling.
    [~, noPoints] = size(points.points);
    if samplingOptions.isProcent
        numberOfSamples = round(noPoints * samplingOptions.value);
    else
        numberOfSamples = samplingOptions.value;
    end
    numberOfSamples = min(numberOfSamples, noPoints);
    
    % Aprox 60% from random sampling and aprox 40% form uniform sampling.
    number_from_random = floor(0.6 * numberOfSamples);
    number_from_uniform = numberOfSamples - number_from_random;
    
    samplingOptions.isProcent = 0;
    
    samplingOptions.value = number_from_random;
    randomSampled = randomSample(points, samplingOptions);
    
    samplingOptions.value = number_from_uniform;
    uniformNormalsSampled = uniformNormalsSample(points, samplingOptions);

    sampledPoints = mergePointClouds(randomSampled,uniformNormalsSampled);
end