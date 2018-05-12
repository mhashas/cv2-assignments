function denseBlocks = getDenseBlocks(pointViewMatrix, maxViewsPerBlock, minPointsPerBlock, minVeiwsPerBlock)
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
%    denseBlocks - N * 4 matrix, where N is the number of blocks and each row is a dense block with y,x of left top corner and height and width of the denseblock
[NViews, NPoints] = size(pointViewMatrix);
currentView = 1;

denseBlocks = [];
while currentView < NViews
    %find the biggest interval of non zero values points from this view 
    % and set that as the width of the dense block
    [startDensePointIdx, stopDensePointIdx] = longestNZSequence(pointViewMatrix(currentView,:));
    
    %if the width is less than minimally required, continue to the next view
    if stopDensePointIdx - startDensePointIdx + 1 < minPointsPerBlock
        currentView = currentView + 1;
        continue
    end
    
    % while all the points are contained count additional views in the dense block
    % all(vector) returns 1 if all values are 1, 0 otherwise
    lastView = currentView + 1;
    while lastView < NViews && lastView - currentView + 1 <= maxViewsPerBlock
        if all(pointViewMatrix(lastView, startDensePointIdx:stopDensePointIdx)) == 1
            lastView = lastView + 1;
        elseif lastView - currentView < minVeiwsPerBlock
            %if the new view is has less points in common with the previous
            %views than the actual block width, but the minimal nr of views
            %per block was not reached, adjust the block width
            [newStartDensePointIdx, newStopDensePointIdx] = longestNZSequence(pointViewMatrix(lastView,startDensePointIdx: stopDensePointIdx));
            if stopDensePointIdx - startDensePointIdx + 1 < minPointsPerBlock
                %this might contain less than the minimal pointsPerBlock, e.g. 1
                break
            else
                startDensePointIdx = startDensePointIdx + newStartDensePointIdx - 1;
                newLength = newStopDensePointIdx - newStartDensePointIdx + 1;
                stopDensePointIdx = startDensePointIdx + newLength - 1;
            end
        else
            break
        end
    end
    
    denseBlocks = [denseBlocks; currentView, startDensePointIdx, lastView-currentView, stopDensePointIdx - startDensePointIdx+1];
    currentView = lastView;
end

end

