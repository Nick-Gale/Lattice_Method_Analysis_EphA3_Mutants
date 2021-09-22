function angles = find_rel_angles(list_of_neighbours,from_points,to_points)

    point_1 = from_points(list_of_neighbours(:,1),:);
    point_2 = from_points(list_of_neighbours(:,2),:);
    vec_1 = point_1 - point_2;
    
    point_1 = to_points(list_of_neighbours(:,1),:);
    point_2 = to_points(list_of_neighbours(:,2),:);
    vec_2 = point_1 - point_2;
    
    
    num_links = size(list_of_neighbours,1);
    vec_1_prime = repmat([-1,1],num_links,1).*fliplr(vec_1);
    x = diag(vec_1*vec_2');
    y = diag(vec_1_prime*vec_2');
    angles = atan2(y,x);



    
