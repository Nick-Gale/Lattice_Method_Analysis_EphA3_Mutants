function [cross_points, list_of_crossings] = make_cross_list(list_of_points, sets_of_intersections)
    
    all_points = unique(sets_of_intersections);
    points_to_remove = setdiff(all_points, list_of_points);
    active_crossings = remove_links_including_nodes(sets_of_intersections, points_to_remove);
    cross_points = unique(active_crossings);
    if ~isempty(active_crossings)
        list_of_crossings = [active_crossings(:,1:2); active_crossings(:,3:4)];
        list_of_crossings = unique(list_of_crossings, 'rows');
    else
        list_of_crossings = [0,0];
        list_of_crossings(1,:) = [];
    end