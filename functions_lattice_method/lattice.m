function object = lattice(direction, indexes, full_field_unique, full_collicular_unique, area_scaling, spacing_points_fraction, spacing_radius_multiplier, spacing_upper_bound, spacing_lower_bound, min_points, triangle_tolerance, max_trial_scale_factor, min_spacing_fraction, min_spacing_reduction_factor, random_seed, create_new_map);
    %record pre-filtered data
    object.collicular_data = full_collicular_unique;
    object.field_data = full_field_unique;
    if direction == 'CTOF'
        full_x = full_collicular_unique(:, 1);
        full_y = full_collicular_unique(:, 2);
    end
    if direction == 'FTOC'
        full_x = full_field_unique(:, 1);
        full_y = full_field_unique(:, 2);
    end
    takeout = [];
    
    if create_new_map == 1
        [num_points_init, obj_radius, lower_mean_min_spacing, upper_mean_min_spacing] = define_spacings(length(indexes), spacing_points_fraction, spacing_radius_multiplier, spacing_upper_bound, spacing_lower_bound);
        %perform the 'digital electrode placement' on a series of retinal indexes
        [chosen_points, stats_area_same_direction, stats_min_spacing, stats_used_hist, stats_use_mean, stats_use_max] = select_point_positions(lower_mean_min_spacing, upper_mean_min_spacing, full_x(indexes), full_y(indexes), num_points_init, min_points, obj_radius, max_trial_scale_factor, min_spacing_fraction, min_spacing_reduction_factor, area_scaling, random_seed);
        chosen_indexes = ismember(full_x(indexes), chosen_points(:, 1)) .* ismember(full_y(indexes), chosen_points(:, 2));
    else
        [num_points_init, obj_radius, lower_mean_min_spacing, upper_mean_min_spacing] = define_spacings(size(full_collicular_unique, 1), spacing_points_fraction, spacing_radius_multiplier, spacing_upper_bound, spacing_lower_bound);

        stats_area_same_direction = NaN; stats_min_spacing = NaN; stats_used_hist = NaN; stats_use_mean = NaN; stats_use_max = NaN;
        chosen_points(:, 1) = full_x(indexes);
        chosen_points(:, 2) = full_y(indexes);
        chosen_indexes = indexes;
    end
    num_points = size(chosen_points, 1);
    candidates = 1:num_points;

    [triangles, neighbours] = triangulate(chosen_points, candidates, triangle_tolerance);
    %create the projection from region to its complement
    [projected_points, stats_area_compliment_direction, candidates] = create_projection(direction, full_field_unique(indexes, :), full_collicular_unique(indexes, :), chosen_points, takeout, num_points, area_scaling, obj_radius);
    
    [list_of_neighbours, sets_of_intersections, stats_link_length_mean, stats_link_length_std, stats_min_link_length_mean, stats_min_link_length_std, stats_num_crossings, stats_nodes_crossing] = find_crossings(projected_points, neighbours);

    [points_in_subgraph, points_not_in_subgraph, percent_edges_in_subgraph, submap_list_of_neighbours, stats_num_nodes_in_subgraph] = find_largest_subgraph(sets_of_intersections, neighbours, list_of_neighbours, takeout, num_points, candidates);

    [full_map_link_ratios_RC, full_map_link_ratios_ML, full_map_flipped_links, full_map_norm_links, full_map_angles, stats_full_map_orientations, stats_full_map_orientation_mean, stats_full_map_orientation_std] = find_link_angles(list_of_neighbours, chosen_points, projected_points, triangles, takeout, points_not_in_subgraph, 1);
    [subgraph_link_ratios_RC, subgraph_link_ratios_ML, subgraph_flipped_links, subgraph_norm_links, subgraph_angles, stats_subgraph_orientations, stats_subgraph_orientation_mean, stats_subgraph_orientation_std] = find_link_angles(list_of_neighbours, chosen_points, projected_points, triangles, takeout, points_not_in_subgraph, 0);

    %field rotation angle is zero to reflect new_single_axis_order_hjorth
    field_rotation_angle = 0;
    [ML_whole, ML_sub, RC_whole, RC_sub, new_field] = new_single_axis_order(list_of_neighbours, points_not_in_subgraph, full_collicular_unique, full_field_unique, field_rotation_angle, points_not_in_subgraph);

    [full_map_relative_area, submap_relative_area, submap_coll_area, submap_field_area] = find_convex_hull(full_collicular_unique, full_field_unique, takeout, num_points, candidates, points_in_subgraph);
    
    %do the coverages
    fbw_x = new_field(:, 1);
    fbw_y = new_field(:, 2);
    [fkw faw] = boundary(fbw_x, fbw_y);
    
    fbs_x = fbw_x(points_in_subgraph);
    fbs_y = fbw_y(points_in_subgraph);
    [fks fas] = boundary(fbs_x, fbs_y);

    cbw_x = full_collicular_unique(find(chosen_indexes), 1);
    cbw_y = full_collicular_unique(find(chosen_indexes), 2);
    [ckw caw] = boundary(cbw_x, cbw_y);

%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Create the lattice object for this particular subset of points
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
    object.numpoints = num_points;
    object.description = 'Placeholder';
    object.lower_mean_min_spacing = lower_mean_min_spacing;
    object.upper_mean_min_spacing = upper_mean_min_spacing;
    object.chosen_points = chosen_points;
    object.chosen_indexes = chosen_indexes;
    object.coll_chosen = full_collicular_unique(find(chosen_indexes), :);
    object.field_chosen = full_field_unique(find(chosen_indexes), :);
    object.candidates = candidates;
    object.triangles = triangles;
    object.projected_points = projected_points;
    object.list_of_neighbours = list_of_neighbours;
    object.sets_of_intersections = sets_of_intersections;
    object.points_in_subgraph = points_in_subgraph;
    object.points_not_in_subgraph = points_not_in_subgraph;
    object.percent_edges_in_subgraph = percent_edges_in_subgraph;
    object.submap_list_of_neighbours = submap_list_of_neighbours;
    object.full_map_link_ratios_RC = full_map_link_ratios_RC;
    object.full_map_link_ratios_ML = full_map_link_ratios_ML;
    object.subgraph_link_ratios_RC = subgraph_link_ratios_RC;
    object.subgraph_link_ratios_ML = subgraph_link_ratios_ML;
    object.subgraph_flipped_links = subgraph_flipped_links;
    object.subgraph_norm_links = subgraph_norm_links;
    object.subgraph_angles = subgraph_angles;
    object.wholemap_RC = RC_whole;
    object.wholemap_ML = ML_whole;
    object.submap_RC = RC_sub;
    object.submap_ML = ML_sub;
    object.full_map_relative_area = full_map_relative_area;
    object.submap_relative_area = submap_relative_area;
    object.submap_coll_area = submap_coll_area;
    object.submap_field_area = submap_field_area;
    
    object.field_cover = faw;
    object.fieldsub_cover = fas;
    object.collsub_cover = caw;
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Create the stats object for this particular subset of points
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
    object.Statistics.stats_area_same_direction = stats_area_same_direction;
    object.Statistics.stats_min_spacing = stats_min_spacing;
    object.Statistics.stats_used_hist = stats_used_hist;
    object.Statistics.stats_use_mean = stats_use_mean;
    object.Statistics.stats_use_max = stats_use_max;
    object.Statistics.stats_area_compliment_direction = stats_area_compliment_direction;
    object.Statistics.stats_link_length_mean = stats_link_length_mean;
    object.Statistics.stats_link_length_std = stats_link_length_std;
    object.Statistics.stats_min_link_length_mean = stats_min_link_length_mean;
    object.Statistics.stats_min_link_length_std = stats_min_link_length_std;
    object.Statistics.stats_link_length_std = stats_link_length_std;
    object.Statistics.stats_min_link_length_mean = stats_min_link_length_mean;
    object.Statistics.stats_num_crossings = stats_num_crossings;
    object.Statistics.stats_nodes_crossing = stats_nodes_crossing;
    object.Statistics.stats_num_nodes_in_subgraph = stats_num_nodes_in_subgraph;
    object.Statistics.stats_full_map_orientations = stats_full_map_orientations;
    object.Statistics.stats_full_map_orientation_mean = stats_full_map_orientation_mean;
    object.Statistics.stats_subgraph_orientations = stats_subgraph_orientations;
    object.Statistics.stats_subgraph_orientation_mean = stats_subgraph_orientation_mean;