function [list_of_neighbours, sets_of_intersections, stats_link_length_mean, stats_link_length_std, stats_min_link_length_mean, stats_min_link_length_std, stats_num_crossings, stats_nodes_crossing] = find_crossings(projected_points, neighbours)
    %Colliculus
    sets_of_intersections = [];
    unique_neighbours = triu(neighbours,1);
    [neighbour1, neighbour2] = find(unique_neighbours);
    list_of_neighbours = [neighbour1, neighbour2];
    num_edges = length(list_of_neighbours);
    for primary_edge = 1:num_edges
        edge1 = list_of_neighbours(primary_edge,:);
        list_of_neigh_to_check = list_of_neighbours(primary_edge:num_edges,:);
        [rows_to_delete, ~] = find(list_of_neigh_to_check==edge1(1)|list_of_neigh_to_check==edge1(2));
        rows_to_delete = unique(rows_to_delete);
        list_of_neigh_to_check(rows_to_delete,:) = [];
        for edge = 1:size(list_of_neigh_to_check,1)
            edge2 = list_of_neigh_to_check(edge,:);
            if doescross(edge1,edge2,projected_points);
                sets_of_intersections = [sets_of_intersections; edge1, edge2];
            end
        end
    end

    [stats_link_length_mean, stats_link_length_std] = find_mean_link_length(list_of_neighbours, projected_points);
    [stats_min_link_length_mean, stats_min_link_length_std] = find_min_link_length_mean(neighbours, projected_points);

    stats_num_crossings = size(sets_of_intersections, 1);
    stats_nodes_crossing = length(unique(sets_of_intersections));
