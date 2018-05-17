function [pv_matrix] = chaining(first_index, last_index, remove_background, threshold)
% chaining - Start from any two consecutive image matches. Add a new column to
% point-view matrix for each newly introduced point.
% If a point which is already introduced in the point-view matrix and an-
% other image contains that point, mark this matching on your point-view
% matrix using the previously defined point column. Do not introduce a new
%
% Syntax:  pv_matrix = chaining(first_index, last_index, threshold)
%
% Inputs:
%   first_index - index of first image to be used
%   last_index  - index of last image to be used
%   remove_background - if 1 we remove background sift
%   threshold   - threshold that is used in vl_ubcmatch. defaults to 5
%                   
%
% Outputs:
%   pv_matrix -  2M * N  matrix, where M is the number of views and N is the 
%                     number of 3D points. The format is:
% 
%                     x1(1)  x2(1)   x3(1) ... xN(1)
%                     y1(1)  y2(1)  y3(1) ... yN(1)
%                     ...
%                     x1(M)  x2(M)   x3(M) ... xN(M)
%                     y1(M)  y2(M)  y3(M) ... yN(M)
%                     where xi(j) and yi(j) are the x- and y- projections of the ith 3D point 
%                     in the jth camera. 
    
    if nargin < 3
        threshold = 5;
    end
    
    for index = first_index:last_index 
         fprintf('Image: %i of %i\n', index, last_index)
            
         image1 = getImage(index);
         
         if index == last_index
            image2 = getImage(1);
         else
            image2 = getImage(index + 1);
         end
        
        % find matching points
        [f1, ~, f2, ~, matches, ~] = getKeypointMatches(image1, image2, threshold);
        
        % get matching points using eight point algorithm
        p1List = f1([1,2], matches(1,:));
        p2List = f2([1,2], matches(2,:));
        
        if remove_background
            [p1List, p2List] = selectPointsInForeground(image1, p1List, image2, p2List);
        end
        
        if size(p1List,2) < 8
            % we don't have 8 points, no reason to do eight point
            % algorithm. usually happens if the threshold is too big
            %continue
        end
        
        [F, p1, p2] = eightPointAlgorithm(p1List, p2List, 0);
        
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