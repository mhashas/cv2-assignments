function denseBlocks = getCommonBlocks(pointViewMatrix, maxViewsPerBlock, minPointsPerBlock, minVeiwsPerBlock)
% getDenseBlocks - This function returns a list of all the dense blocks in the pointViewMatrix
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
%   maxViewsPerBlock - int, maximum nr of views per block ( rows )
%   minPointsPerBlock - int, minimum nr of points per block ( columns )
%   minVeiwsPerBlock - int, maximum nr of points per block ( columns )
% Outputs:
%    denseBlocks - N * 1 array, where N is the number of blocks and each
%    element is a denseBlock
%    denseBlock - structure: 
%                      * db.startView - index of first view of dense block
%                      * db.endView - index of last view of dense block
%                      * db.indices - list of common points in all the
%                      views from db.startView to db.endView
[NViews, NPoints] = size(pointViewMatrix);
currentView = 1;

denseBlocks = [];
while currentView < NViews
    % COMMENT
    
    if mod(currentView ,2)==0
        currentView = currentView + 1;
    end
    
    lastView = currentView;
    commonPointsIndeces = find(pointViewMatrix(currentView,:));
    while lastView < NViews && lastView - currentView + 1 <= maxViewsPerBlock
        lastView = lastView + 1;
        
        newViewPointIndices = find(pointViewMatrix(lastView,:));
        candidateIndices = intersect(commonPointsIndeces, newViewPointIndices);
        
        if length(candidateIndices) == length(commonPointsIndeces)
            %basically do nothing
            continue
        elseif lastView - currentView < minVeiwsPerBlock
            %if the new view is has less points in common with the previous
            %views than the actual block width, but the minimal nr of views
            %per block was not reached, adjust the block width
            if length(candidateIndices) < minPointsPerBlock
                % this might contain less than the minimal pointsPerBlock, e.g. 1
                % so we stop
                lastView = lastView - 1;
                break
            else
                commonPointsIndeces = candidateIndices;
            end
        else
            %we can deliniate a block that ends here
            lastView = lastView - 1;
            break
        end
    end
    
%     if mod(lastView,2) ~= 0
%         lastView = lastView - 1;
%     end
    if lastView - currentView + 1 >= minVeiwsPerBlock
        db = struct;
        db.startView = currentView;
        db.endView = lastView;
        db.indices = commonPointsIndeces;
        denseBlocks = [denseBlocks; db];
    end
    currentView = lastView + 1;
end

