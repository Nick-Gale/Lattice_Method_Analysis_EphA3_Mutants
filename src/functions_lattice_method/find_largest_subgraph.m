function [points_in_subgraph, points_not_in_subgraph, percent_edges_in_subgraph, submap_list_of_neighbours, stats_num_nodes_in_subgraph] = find_largest_subgraph(sets_of_intersections, neighbours, list_of_neighbours, takeout, num_points, candidates)

	candidates = setdiff(candidates, takeout);
    active_sets_of_intersections = remove_links_including_nodes(sets_of_intersections,takeout);

    points_not_in_subgraph = takeout;
    active_list_of_neighbours = remove_links_including_nodes(list_of_neighbours,takeout);
    
    while ~isempty(active_sets_of_intersections)
        intersection_points = unique(active_sets_of_intersections(:));
        count = hist(active_sets_of_intersections(:),intersection_points);
        [~,sorted_points] = sort(count,'descend');
        intersection_points = intersection_points(sorted_points);

        points_to_remove = find_worst_point(intersection_points,...
            active_list_of_neighbours,active_sets_of_intersections);
        points_not_in_subgraph = [points_not_in_subgraph; points_to_remove'];
        active_sets_of_intersections = remove_links_including_nodes(active_sets_of_intersections,points_to_remove);
        active_list_of_neighbours = remove_links_including_nodes(active_list_of_neighbours,points_to_remove);
    end
    
    points_in_subgraph = setdiff(candidates, points_not_in_subgraph);
    
    sum1 = sum(sum(neighbours(:,:)));
    sum2 = sum(sum(neighbours(points_in_subgraph, points_in_subgraph)));
    percent_edges_in_subgraph = 100 * sum2 / sum1;
    submap_list_of_neighbours = active_list_of_neighbours;

    stats_num_nodes_in_subgraph = length(points_in_subgraph);
    