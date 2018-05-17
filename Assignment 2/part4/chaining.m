function [pv_matrix] = chaining(first_index, last_index)
    for index = first_index:last_index 
         fprintf('Image: %i of %i\n', index, last_index)
            
         image1 = getImage(index);
         
         if index == last_index
            image2 = getImage(1);
         else
            image2 = getImage(index + 1);
         end
           
        % find matching points
        [f1, ~, f2, ~, matches, ~] = getKeypointMatches(image1, image2, 5);
        
        % get matching points using eight point algorithm
        p1List = f1([1,2], matches(1,:));
        p2List = f2([1,2], matches(2,:));
        
        %[p1List, p2List] = selectPointsInForeground(image1, p1List, image2, p2List);
        
        [F, p1, p2] = eightPointAlgorithm(p1List, p2List, 0);
        
        % handle outliers with F ? Should it be handled in eightPoint ? 
        
        if index == 1
            % first iteration 
            pv_matrix = [p1(1:2, :); p2(1:2, :)];
        else
            % need to check if there are same points in the previous frame
            previous_pvm = pv_matrix(end-1:end,:); 
            pv_matrix = vertcat(pv_matrix, zeros(2, length(pv_matrix)));
          
            % for all points
            new_points_indices = [];
            for n = 1: size(p1, 2)
                % check if points from the first image have appeared before
                [~, intersect_x_indices] =  intersect(previous_pvm(1, :), p1(1, n));
                [~, intersect_y_indices] =  intersect(previous_pvm(2, :), p1(2, n));
                [~, matched_points] = intersect(intersect_x_indices, intersect_y_indices);

                if (size(matched_points, 1) >= 1)
                    % add matched points from the second image
                    matched_points_index = intersect_x_indices(matched_points);
                    pv_matrix(end-1:end, matched_points_index) = p2(1:2, n);
                else
                    % track points that have not appeared before
                    new_points_indices = [new_points_indices, n];                                
                end
            end
            
            % insert new points
            number_of_new_points = size(new_points_indices, 2);
            new_points = vertcat(p1(1:2, new_points_indices), p2(1:2, new_points_indices));
            pv_matrix = [pv_matrix, zeros(size(pv_matrix, 1), number_of_new_points)];
            pv_matrix(end-3 : end, size(pv_matrix, 2)-number_of_new_points+1: end) = new_points;
        end
    end
end