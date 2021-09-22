function [from_points,projection_points] = find_projection(centre, radius, from_coords, to_coords)
% FIND_PROJECTION - find projection of a centre
    within_radius = find_within_radius(centre, radius, from_coords);
    from_points = from_coords(within_radius, :);
    projection_points = to_coords(within_radius, :);
