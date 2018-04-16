function pcd = getPcd(filename, type, sampleSize)
    pcd = readPcd(filename);
    
    % filter out z-values, greater than 2
    index = (pcd(:, 3) <2);
    pcd = pcd(index, :);
    
    % base with onl x,y,z values
    pcd = pcd(:,1:3);
    
    if strcmp(type, 'uniform_sub_sampling')
        ids = randsample(1:size(pcd,1), sampleSize);
        pcd = pcd(ids, :);
    end
end