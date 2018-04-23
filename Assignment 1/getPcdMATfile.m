function pcd = getPcdMATfile(filename)
    pcd = load(filename);
    
    if isfield(pcd, 'points') == 1
        pcd = pcd.points;
    elseif isfield(pcd, 'normal') == 1
        pcd = pcd.normal;
    end
    % filter out z-values, greater than 2
    index = (pcd(:, 3) < 2);
    pcd = pcd(index, :);
    
    % base with onl x,y,z values
    pcd = pcd(:,1:3);
end

