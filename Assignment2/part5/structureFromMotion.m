function [stitchedPoints] = structureFromMotion(pointViewMatrix, denseBlocks, transformationOrder, prioritize, affineAmbiguity, removeBackground, allignMethod)
% structureFromMotion - This function stitches together the points of the
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
%    denseBlocks - N * 1 array, where N is the number of blocks and each element is a denseBlock
%    denseBlock - structure: 
%                      * db.startView - index of first view of dense block
%                      * db.endView - index of last view of dense block
%                      * db.indices - list of common points in all the views from db.startView to db.endView
%   transformationOrder - "oneToAll" | "allToOne"
%                              oneToAll, transforms all the points at the moment to the points from the next block for each new block. a
%                              allToOne, transforms all the points of the new block to all the points up to this block for every block
%   prioritize - "source" | "target"
%                                 source, after matching points from different blocks, we keep points from the source
%                                 source, after matching points from different blocks, we keep points from the target
%   removeBackground - if 1, remove background; do nothing otherwise 
%   affineAmbiguity  - if 1, apply affine ambiguity
%   allignMethod     - "icp" | "procrustes" method to use when alligning common points from separate denseblocks; when alligning denseblocks
% Outputs:
%    stitchedPoints - 3 * N matrix, where N is the nr of points in the pointViewMatrix. Contains 3D coordinates of each point
[NViews, NPoints] = size(pointViewMatrix);
[nrOfBlocks, ~] = size(denseBlocks);
stitchedPoints = NaN(3, NPoints);

for blockIdx = 1:nrOfBlocks
    denseBlock = denseBlocks(blockIdx,:);
    [M, S, t] = factorization(pointViewMatrix(denseBlock.startView:denseBlock.endView, denseBlock.indices), affineAmbiguity);
    
    if removeBackground == 1
        %remove noise
        good_indices_in_S = find(S(3,:)<3 & S(3,:)> -3);
        denseBlock.indices = denseBlock.indices(good_indices_in_S);
        
        %REDO factorization wothout outliers
        [M, S, t] = factorization(pointViewMatrix(denseBlock.startView:denseBlock.endView, denseBlock.indices), affineAmbiguity);
        good_indices_in_S = find(S(3,:)<3 & S(3,:)> -3);
        denseBlock.indices = denseBlock.indices(good_indices_in_S);
        
        S = S(:,good_indices_in_S);
%         plot3D(S,'black.');
%         figure 
%         plot3D(S,'black.');
    end
    
    if length(find(~isnan(stitchedPoints(1,denseBlock.indices)))) == 0
        fprintf("adding new view\n");
        stitchedPoints(:,denseBlock.indices) = S;
        stitchedIndices = denseBlock.indices;
        
    else
        % get the indexes in denseBlock of common points
        commonIndices = intersect(stitchedIndices, denseBlock.indices);
        
        commonIndicesofDenseBlockInS = getIndicesOfAInB(commonIndices, denseBlock.indices);
        % S is shape from the factorization of the dense block
        % procrustes from denseBlock to main view
        if transformationOrder == "allToOne"
            %% all to one method and always prioritize points from main view
            if allignMethod == "procrustes"
                %% RUN procrustes
                [error,~,transform] = procrustes(stitchedPoints(:,commonIndices)', S(:,commonIndicesofDenseBlockInS)');
                transformed_points = transform.b*S'*transform.T + transform.c(1,:);
            elseif allignMethod == "icp"
                %% Run ICP
                [rotation, translation, ER, t] = icp(stitchedPoints(:,commonIndices), S(:,commonIndicesofDenseBlockInS),20);
                transformed_points = rotation * S + translation;
                transformed_points = transformed_points';
            else
                error("BAD allignMethod argument");
            end
            
            if prioritize == "target"
                % choose the points in the factorization of the denseBlock which
                % are missing in the main view and add them to the main view
                idx = 0;
                for i = denseBlock.indices
                    idx = idx + 1;
                    if isnan(stitchedPoints(1,i))
                        stitchedPoints(:,i) = transformed_points(idx,:)';
                        stitchedIndices = union(stitchedIndices, denseBlock.indices);
                    end
                end
            elseif prioritize == "source"
                % add all the points from the factorization of the dense block
                % and copy and replace them to the main view
                stitchedPoints(:,denseBlock.indices) = transformed_points(:,:)';
                stitchedIndices = union(stitchedIndices, denseBlock.indices);
            else
                fprintf("Wrong parameter");
            end
        elseif transformationOrder == "oneToAll"
            %% one to all method
            if allignMethod == "procrustes"
                %% RUN procrustes
                [error,~,transform] = procrustes(S(:,commonIndicesofDenseBlockInS)', stitchedPoints(:,commonIndices)');
                transformed_points = transform.b*stitchedPoints'*transform.T + transform.c(1,:);
                stitchedPoints = transformed_points';
            elseif allignMethod == "icp"
                %% Run ICP
                [rotation, translation, ER, t] = icp(S(:,commonIndices), stitchedPoints(:,commonIndicesofDenseBlockInS),20);
                transformed_points = rotation * stitchedPoints + translation;
                transformed_points = transformed_points';
            else
                error("BAD allignMethod argument");
            end
            
            if prioritize == "source"
                % choose the points in the factorization of the denseBlock which
                % are missing in the main view and add them to the main view
                idx = 0;
                for i = denseBlock.indices
                    idx = idx + 1;
                    if isnan(stitchedPoints(1,i))
                        stitchedPoints(:,i) = S(:,idx);
                    end
                end
                stitchedIndices = union(stitchedIndices, denseBlock.indices);
            elseif prioritize == "target"
                % add all the points from the factorization of the dense block
                % and copy and replace them to the main view
                stitchedPoints(:,denseBlock.indices) = S(:,:);
                stitchedIndices = union(stitchedIndices, denseBlock.indices);
            else
                fprintf("Wrong parameter");
            end
        else
            fprintf("Wrong parameter");
        end

    end
end
end