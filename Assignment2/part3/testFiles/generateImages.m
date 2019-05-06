frames = [1 5; 1 30]';  % 2 by P matrix;
thresholds = [1, 1.5, 2, 3, 4, 5];
backgroundRemovalOptions = ["all", "both"];
directory = pwd + "/part3/testFiles/images/";

for f=1:size(frames,2)
    frame = frames(:,f);
    id1 = frame(1,1);
    id2 = frame(2,1);
    image1 = getImage(id1);
    image2 = getImage(id2);
    
    fullName = fullfile(char(directory), char(sprintf('mask_%d.png',id1)));
    saveas(imshow(getMask(image1, 200)), fullName);
    fullName = fullfile(char(directory), char(sprintf('image_%d.png',id1)));
    saveas(imshow(image1), fullName);
    
    fullName = fullfile(char(directory), char(sprintf('mask_%d.png',id2)));
    saveas(imshow(getMask(image2, 200)), fullName);
    fullName = fullfile(char(directory), char(sprintf('image_%d.png',id2)));
    saveas(imshow(image2), fullName);
    

    for threshold = thresholds
        [f1, ~, f2, ~, matches, ~] = getKeypointMatches(image1, image2, threshold);
        p1List = f1([1,2], matches(1,:));
        p2List = f2([1,2], matches(2,:));
        
        for backgroundRemovalOption = backgroundRemovalOptions
            [p1, p2] = selectPointsInForeground(image1, p1List, image2, p2List, backgroundRemovalOption);
            figure = showCorespondences(image1, image2, p1, p2);
            fileName = sprintf('opt_img_%dto%d_threshold_%0.1f_backgroundRemoval_%s.png',id1,id2,threshold,backgroundRemovalOption);
            fullName = fullfile(char(directory), char(fileName));
            saveas(figure, fullName);
            
            [F2, p21, p22] = eightPointAlgorithm(p1, p2, 2);
            figure = showCorespondences(image1, image2, p21, p22);
            fileName = sprintf('opt_RANSAC_img_%dto%d_threshold_%0.1f_backgroundRemoval_%s.png',id1,id2,threshold,backgroundRemovalOption);
            fullName = fullfile(char(directory), char(fileName));
            saveas(figure, fullName);
        end
    end
end