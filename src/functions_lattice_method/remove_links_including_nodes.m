function active_list = remove_links_including_nodes(link_list, nodes)
%Takes a list of links or crossings and a list of nodes and removes all
%links or crossings that contain nodes in the list of nodes.

    [row, ~] = find(ismember(link_list, nodes));
    row = unique(row);
    active_list = link_list;
    active_list(row, :) = [];