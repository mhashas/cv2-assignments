function sampledPoints = samplePoints(points, sampling)
    % sampling is a struct containing 
    % sampling.name = 'all'|'random'|'random per iteration'|'informative'
    % sampling.size = size of sample
    % sampling.normals.target and sampling.normals.source when sampling.name = 'informative'
    % sampling.noise_removal = 0 | 1
    % if sampling.noise_removal = 1 there should be a sampling.target
    
    switch sampling.name
        case 'all'
            sampledPoints = points;
        case 'random'
            [~, noPoints] = size(points);
            randomPermutation = randperm(noPoints);
            numberOfSamples = min(sampling.size, noPoints);
            randomPermutation = randomPermutation(1:numberOfSamples);
            sampledPoints = points(:,randomPermutation);
        case 'random per iteration'
            %identical to random
            [~, noPoints] = size(points);
            randomPermutation = randperm(noPoints);
            numberOfSamples = min(sampling.size, noPoints);
            randomPermutation = randomPermutation(1:numberOfSamples);
            sampledPoints = points(:,randomPermutation);
        case 'informative'
            [dims, noPoints] = size(points);
            
            sampled_indexes = zeros(1, ceil(sampling.size/3));
            index_in_sampled_indexes = 1;
            for i = 1:dims
                % e.g. 101 edges for 100 bins
                edges = [min(min(sampling.normals.source(i,:))):2/ceil(sampling.size/3):max(max(sampling.normals.source(i,:)))];
                
                %CHECK HERE IF INDEXES OF NANS ARE THROWN, IF SO WE NEED TO
                %MAKE UP FOR THAT
                
                %divide into the number of points we are looking for
                [N, edges, bins] = histcounts(sampling.normals.source(i,:),edges);
                
                %take one from each bucket
                %visited array
                visited_array = zeros(1, ceil(sampling.size/3));
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
            sampledPoints = points(:, sampled_indexes);
        otherwise
            throw(MException('bad sampler name', 'bad sampler name'));
    end
    
    if sampling.noise_removal == 1
        target = sampling.target;
        %remove 10% worst points ( probably at the edge of the pcd ) based on
        %distance to the franeTwo
        [mins_distance, ~] = getMatchingPoints(sampledPoints, target);
        %get the index in frameOne
        [~, worsts_idx] = maxk(mins_distance, floor(length(mins_distance)/20));
        %remove them from the sample
        sampledPoints( :, [worsts_idx]) = []; 
    end

end