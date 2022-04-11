function [full_map_relative_area, submap_relative_area, submap_coll_area, submap_field_area] = find_convex_hull(coll_points, field_points, takeout, numpoints, candidates, points_in_subgraph);

    %full map
    [K1,A1] = convhull(coll_points(candidates, 1),coll_points(candidates, 2));
    [K2,A2] = convhull(field_points(candidates, 1),field_points(candidates, 2));
    full_map_relative_area = A2/A1;

    %submap
    [K1,A1] = convhull(coll_points(points_in_subgraph,1), coll_points(points_in_subgraph,2));
    [K2,A2] = convhull(field_points(points_in_subgraph,1), field_points(points_in_subgraph,2));
    submap_relative_area = A2/A1;
    submap_coll_area = A1;
    submap_field_area = A2;