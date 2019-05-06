function sparse_pointview_matrix = add_random_sparseness(pointview_matrix, probability)
% In matrix pointviewmatrix, set a value to 0 with probability probability
[H, W] = size(pointview_matrix);
random_samples = random('Discrete Uniform', 100, H, W);
sparse_pointview_matrix = pointview_matrix;
sparse_pointview_matrix(random_samples <= probability) = 0;
end

