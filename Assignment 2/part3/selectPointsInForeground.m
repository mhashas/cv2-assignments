function [points1, points2] = selectPointsInForeground(image1, points1, image2, points2, option)
%   option = 'all' | 'both' | 'first' | 'second'
    if ~exist('option','var') || isempty(option)
        option = 'all';
    end 
    
    if strcmp(option, 'all')
        points1 = points1;
        points2 = points2;
    else
        mask1 = getMask(image1, 200);
        index = sub2ind(size(mask1),round(points1(2,:)),round(points1(1,:)));
        selectedPointsIndices1 = mask1(index) == 1; 

        mask2 = getMask(image2, 200);
        index = sub2ind(size(mask2),round(points2(2,:)),round(points2(1,:)));
        selectedPointsIndices2 = mask2(index) == 1; 

        selectedPointsIndices = getSelectedPointsByOption(selectedPointsIndices1, selectedPointsIndices2, option);

        points1 = points1(:, selectedPointsIndices);
        points2 = points2(:, selectedPointsIndices); 
    end
end

function [selectedIndices] = getSelectedPointsByOption(selectedPointsIndices1, selectedPointsIndices2, option)
    switch option
        case 'both'
            selectedIndices = selectedPointsIndices1 & selectedPointsIndices2;
        case 'first'
            selectedIndices = selectedPointsIndices1;
        case 'second'
            selectedIndices = selectedPointsIndices2;
        case 'all'
            selectedIndices = selectedPointsIndices1 | 1 ;
    end
end