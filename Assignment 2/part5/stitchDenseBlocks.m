function [stitchedPoints] = stitchDenseBlocks(pointViewMatrix, denseBlocks, transformationOrder, prioritize)
% stitchDenseBlocks - This function stitches together the points of the
% dense blocks and returns the stitched points
%
% Inputs:
%   pointViewMatrix -  2M * N  matrix, where M is the number of views and N is the 
%                     number of 3D points. The format is:
% 
%                     x1(1)  x2(1)   x3(1) ... xN(1)
%                     y1(1)  y2(1)  y3(1) ... yN(1)
%                     ...
%                     x1(M)  x2(M)   x3(M) ... xN(M)
%                     y1(M)  y2(M)  y3(M) ... yN(M)
%                     where xi(j) and yi(j) are the x- and y- projections of the ith 3D point 
%                     in the jth camera. 
%   denseBlocks - N * 4 matrix, where N is the number of blocks and each row is a dense block with y,x of left top corner and height and width of the denseblock
%   transformationOrder - "oneToAll" | "allToOne"
%                              oneToAll, transforms all the points at the moment to the points from the next block for each new block. a
%                              allToOne, transforms all the points of the new block to all the points up to this block for every block
%   prioritize - "source" | "target"
%                                 source, after matching points from different blocks, we keep points from the source
%                                 source, after matching points from different blocks, we keep points from the target
% Outputs:
%    stitchedPoints - 3 * N matrix, where N is the nr of points in the pointViewMatrix. Contains 3D coordinates of each point
[NViews, NPoints] = size(pointViewMatrix);
[nrOfBlocks, ~] = size(denseBlocks);
stitchedPoints = NaN(3, NPoints);
for blockIdx = 1:nrOfBlocks
    denseBlock = denseBlocks(blockIdx,:);
    y = denseBlock(1);
    x = denseBlock(2);
    h = denseBlock(3);
    w = denseBlock(4);
    [M, S, t] = factorization(pointViewMatrix(y:y+h-1,x:x+w-1));
    
    
    if longestNZSequence(stitchedPoints(1,x:x+w-1)) == 0
        fprintf("adding new view'r.'\n");
        stitchedPoints(:,x:x+w-1) = S;
    else
        %% all to one method and always prioritize points from main view
        % get the indexes in denseBlock of common points
        [startIdx, stopIdx] = longestNZSequence(stitchedPoints(1,x:x+w-1));
        
        % S is shape from the factorization of the dense block
        % procrustes from denseBlock to main view
        if transformationOrder == "allToOne"
            [error,~,transform] = procrustes(stitchedPoints(:,x+startIdx-1:x+stopIdx-1)', S(:,startIdx:stopIdx)');
            transformed_points = transform.b*S'*transform.T + transform.c(1,:);
            if prioritize == "target"
                % choose the points in the factorization of the denseBlock which
                % are missing in the main view and add them to the main view
                for i = x:x+w-1
                    if isnan(stitchedPoints(1,i))
                        stitchedPoints(:,i) = transformed_points(i-x+1,:)';
                    end
                end
            elseif prioritize == "source"
                % add all the points from the factorization of the dense block
                % and copy and replace them to the main view
                stitchedPoints(:,x:x+w-1) = transformed_points(:,:)';
            else
                fprintf("Wrong parameter");
            end
        elseif transformationOrder == "oneToAll"
            %% one to all method
            [error,~,transform] = procrustes(S(:,startIdx:stopIdx)', stitchedPoints(:,x+startIdx-1:x+stopIdx-1)');
            transformed_points = transform.b*stitchedPoints'*transform.T + transform.c(1,:);
            stitchedPoints = transformed_points';
            if prioritize == "source"
                % choose the points in the factorization of the denseBlock which
                % are missing in the main view and add them to the main view
                for i = x:x+w-1
                    if isnan(stitchedPoints(1,i))
                        stitchedPoints(:,i) = S(:,i-x+1);
                    end
                end
            elseif prioritize == "target"
                % add all the points from the factorization of the dense block
                % and copy and replace them to the main view
                stitchedPoints(:,x:x+w-1) = S(:,:);
            else
                fprintf("Wrong parameter");
            end
        else
            fprintf("Wrong parameter");
        end

    end
end
end

