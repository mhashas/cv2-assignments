function plot_pv_matrix(pv_matrix)
    image = getImage(1);
    imshow(image);
    for row_index = 1:2:size(pv_matrix,1)-1
        for col_index = 1:size(pv_matrix,2)
            x = pv_matrix(row_index, col_index);
            y = pv_matrix(row_index + 1, col_index);
            if x == 0 && y == 0
                continue
            end
            hold on
            plot(x, y,'r*')
            hold off
        end
    end  
end