function plot_pv_matrix(pv_matrix)
    image = getImage(1);
    imshow(image);
    hold all
    for row_index = 1:2:size(pv_matrix,1)-1
        plot(pv_matrix(row_index,:),pv_matrix(row_index+1,:),'r*')
    end  
end