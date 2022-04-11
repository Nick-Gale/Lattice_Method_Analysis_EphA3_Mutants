function within_radius = find_within_radius(centre, radius, coords)
% FIND_WITHIN_RADIUS - Find indicies of points within radius of centre
    distance_from_centre = sqrt((coords(:,1) - centre(1)).^2 + (coords(:,2) - centre(2)).^2);
    
    within_radius = distance_from_centre <= radius;
