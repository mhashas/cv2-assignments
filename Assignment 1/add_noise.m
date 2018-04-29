function pcd = add_noise(pcd, noise_type, sigma_type)
    %noise_type = "gaussian"|"salt and pepper"|"none"
    %if noise is "none" the same pcd is returned
    %if noise type is "gaussian", the sigma_type parameter is used for
    %inferring a sigma
    %sigma_type = "small"|"big"
    
    [sz1, sz2] = size(pcd);
    %add noise for each dimension
    switch noise_type
        case "gaussian"
            for i = 1:sz1
                min_v = min(pcd(i,:));
                max_v = max(pcd(i,:));
                distance = max_v - min_v;
                if sigma_type == "small"
                    % 95% between
                    sigma = distance/50; 
                elseif sigma_type == "big"
                    % 95% between
                    sigma = distance/30;
                end
                
                noise = normrnd(0, sigma, 1, sz2);
                pcd(i,:) = noise + pcd(i,:);
            end
        case "salt and pepper"
            for i = 1:sz1
                min_v = min(pcd(i,:));
                max_v = max(pcd(i,:));
                
                %add noise to 20%; 10 for salt, 10 for pepper
                noise = unidrnd(10, 1, sz2);
                pcd(i, [noise == 1]) = min_v;
                pcd(i, [noise == 10]) = max_v;
            end
        case "none"
            pcd = pcd;
    end
end

