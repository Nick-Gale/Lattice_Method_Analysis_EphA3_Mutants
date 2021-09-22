function [num_nodes_removed, num_links_removed, nodes_removed] = find_num_disconnected_points(candidate,list_of_neighbours,sets_of_intersections)
%Takes a node, a list of neighbours and a list of intersections and finds
%how many subgraphs would result from removing that node. It finds the
%largest subgraph and returns the number of nodes that would have to be
%removed because they were disconnected from the main subgraph, the number 
%of crossing links that would be removed by removing those nodes and the
%identity of the nodes removed.

    total_nodes = unique(list_of_neighbours);
    num_total_nodes = length(total_nodes);
    active_list_of_neighbours = remove_links_including_nodes(list_of_neighbours,candidate);
    subgraph_index = 1;
    subgraph = zeros(1,num_total_nodes);
    subgraph(subgraph_index,1:2) = active_list_of_neighbours(1,:);
    active_list_of_neighbours(1,:) = [];
    %makes sure nodes that are only attached to the candidate are included
    %in nodes to remove because they will have disappeared from the active
    %list of neighbours
    nodes_to_remove = setdiff(total_nodes,unique(active_list_of_neighbours))';
    
    while ~isempty(active_list_of_neighbours)
        connected_links = ismember(active_list_of_neighbours,subgraph(subgraph_index,:));
        [links_in_subgraph,~] = find(connected_links);
        %when none of the current links are connected to any node in the
        %current subgraph start a new subgraph
        if isempty(links_in_subgraph)
            subgraph_index = subgraph_index + 1;
            subgraph(subgraph_index,1:2) = active_list_of_neighbours(1,:);
            active_list_of_neighbours(1,:) = [];
            continue
        end     
        connected_nodes = active_list_of_neighbours(links_in_subgraph,:);
        new_nodes = unique(connected_nodes);
        if iscolumn(new_nodes)
            new_nodes = new_nodes';
        end
        old_nodes = subgraph(subgraph_index,:) > 0;
        nodes = unique([subgraph(subgraph_index,old_nodes),new_nodes]);
        num_nodes = length(nodes); 
        subgraph(subgraph_index,1:num_nodes) = nodes;
        active_list_of_neighbours(links_in_subgraph,:) = [];
    end
    
        
    subgraph_sizes = sum(subgraph>0,2);
    [~, max_subgraph_location] = max(subgraph_sizes);
    nodes_removed = subgraph;
    nodes_removed(max_subgraph_location,:) = [];
    nodes_removed = nodes_removed(nodes_removed>0);
    if iscolumn(nodes_removed)
            nodes_removed = nodes_removed';
    end

    if iscolumn(nodes_to_remove)
            nodes_to_remove = nodes_to_remove';
    end

    nodes_removed = [nodes_removed,nodes_to_remove];
    num_nodes_removed = length(nodes_removed);
    links_to_remove = ismember(sets_of_intersections,nodes_removed);
    [links_removed,~] = find(links_to_remove);
    links_removed = unique(links_removed);
    num_links_removed = length(links_removed);
        
    
    
