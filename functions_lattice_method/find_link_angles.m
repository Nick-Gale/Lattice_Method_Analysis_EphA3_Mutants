function [link_ratios_RC, link_ratios_ML, flipped_links, norm_links, angles, orientations, stats_orientation_mean, stats_orientation_std ] = find_link_angles(list_of_neighbours, from_coords, to_coords, triangles, takeout, points_not_in_subgraph, fullmap)
% This includes code to generate ratios of link lengths rostrocaudally to those of matching links nasotemporally; and similarly for mediolateral axis

    
    list_of_neighbours = remove_links_including_nodes(list_of_neighbours, takeout);
    triangles = remove_links_including_nodes(triangles, takeout);

    num_links = size(list_of_neighbours,1);
    angles = find_rel_angles(list_of_neighbours,from_coords,to_coords);
    
    [link_ratios_RC, link_ratios_ML] = find_projected_distances(list_of_neighbours,from_coords,to_coords);

    orientations = find_flipped_triangles(triangles,from_coords,to_coords);
    norm_links = zeros(num_links,1);
    flipped_links = zeros(num_links,1);
    
    for link = 1:num_links
        active_link = list_of_neighbours(link,:);
        nodes_in_triangles = ismember(triangles,active_link);
        link_in_triangles = sum(nodes_in_triangles,2) >= 2;
        link_member_of = orientations(link_in_triangles);

        num_el = length(link_member_of);
        if sum(link_member_of) < num_el
	        flipped_links(link) = 1;
        end
        
        if sum(link_member_of) > 0
	        norm_links(link) = 1;
        end
    end

    stats_orientation_mean = circ_mean(angles);
    stats_orientation_std = circ_std(angles);