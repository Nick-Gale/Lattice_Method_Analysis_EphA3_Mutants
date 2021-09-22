function worst_points = find_worst_point(intersection_points,list_of_neighbours,sets_of_intersections)
%Takes a list of nodes which participate in crossings, ordered from the one
%that participates in most corssings to the one that participates in least,
%a list of neighbouring points, and a list of intersections and returns the
%worst points, ie the best points to remove. This is done by calculating
%the badness for the first point. If the first point removes more than 1
%node then the badness for the next points in line are calculated and
%compared until a node is reached that removes a single point. Because
%they are ordered by num_links_removed no node below one that removes a
%single link will have a higher badness.

    num_intersection_points = length(intersection_points);
    node_to_test = 1;
    candidate = intersection_points(node_to_test);
    [num_nodes_removed, num_links_removed,nodes_removed] = find_num_disconnected_points(candidate,list_of_neighbours,sets_of_intersections);
    badness = num_links_removed/num_nodes_removed;
    
    while num_nodes_removed > 1 && node_to_test < num_intersection_points
        node_to_test = node_to_test + 1;
        candidate = intersection_points(node_to_test);
        [num_nodes_removed, num_links_removed,new_nodes_removed] = find_num_disconnected_points(candidate,list_of_neighbours,sets_of_intersections);
        new_badness = num_links_removed/num_nodes_removed;
        if badness < new_badness
            badness = new_badness;
            nodes_removed = new_nodes_removed;
        end
    end
        
        
    worst_points = nodes_removed;
    
      
    