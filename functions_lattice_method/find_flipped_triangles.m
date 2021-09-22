function orientations = find_flipped_triangles(triangles,from_coords,to_coords)

    A_from = from_coords(triangles(:,1),:);
    B_from = from_coords(triangles(:,2),:);
    B_from = B_from - A_from;
    C_from = from_coords(triangles(:,3),:);
    C_from = C_from - A_from;
    
    det_from = B_from(:,1).*C_from(:,2) - B_from(:,2).*C_from(:,1);
    
    A_to = to_coords(triangles(:,1),:);
    B_to = to_coords(triangles(:,2),:);
    B_to = B_to - A_to;
    C_to = to_coords(triangles(:,3),:);
    C_to = C_to - A_to;
    
    det_to = B_to(:,1).*C_to(:,2) - B_to(:,2).*C_to(:,1);
    
    orientations = det_from.*det_to > 0;
    
    