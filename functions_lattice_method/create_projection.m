function [projected_points, area, candidates] = create_projection(direction, full_field, full_coll, chosen_points, takeout, num_points, area_scaling, radius)

    set_points = chosen_points;
    set_points(takeout, :) = [];
    if direction == "FTOC"
        to_coords = full_coll;
        from_coords = full_field;
    end

    if direction == "CTOF"
        to_coords = full_field;
        from_coords = full_coll;
    end

    projected_points = zeros(num_points, 2);
    for point = 1:num_points
        centre = set_points(point,:);
        [~, all_projected_points] = find_projection(centre, radius, from_coords, to_coords);
        mean_projection = mean(all_projected_points, 1);
        projected_points(point,:) = mean_projection;
    end


    if length(projected_points(~isnan(projected_points(:,1)))) > 2 
        [~, area] = convhull(projected_points(~isnan(projected_points(:,1)), 1), projected_points(~isnan(projected_points(:,1)), 2));
    else
        area = 0;
    end

    candidates = [1:num_points];
