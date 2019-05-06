function [pcd, pcd_n] = getPcdMATfile(filename)
    %filename is without the extension
    pcd = load(strcat(filename, '.mat'));
    pcd = pcd.points;
    
    if nargout == 2
        pcd_n = load(strcat(filename,'_normal.mat'));
        pcd_n = pcd_n.normal;
    end
    
    %filter out z-values, greater than 2
    index = (pcd(:, 3) < 2);
    pcd = pcd(index, :);
    if nargout == 2
        pcd_n = pcd_n(index, :);
        pcd_n = pcd_n';
    end
    
    % base with onl x,y,z values
    pcd = pcd(:,1:3);
    pcd = pcd';
end

