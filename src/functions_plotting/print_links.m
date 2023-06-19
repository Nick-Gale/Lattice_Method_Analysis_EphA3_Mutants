function [] = print_links(list_of_points, coords, list_of_neighbours, color, linewidth)
    if (~exist('linewidth'))
        linewidth = 0.5;
    end

    all_nodes = unique(list_of_neighbours);
    nodes_to_remove = setdiff(all_nodes, list_of_points);
    active_list_of_neighbours = remove_links_including_nodes(list_of_neighbours, nodes_to_remove);
    point1_x = coords(active_list_of_neighbours(:,1),1)';
    point2_x = coords(active_list_of_neighbours(:,2),1)';
    point1_y = coords(active_list_of_neighbours(:,1),2)';
    point2_y = coords(active_list_of_neighbours(:,2),2)';

    if any(isnan(point1_x)) || any(isnan(point2_x)) || any(isnan(point1_y)) || any(isnan(point2_y))
        disp(coords(isnan(coords(:,1)),1))
        disp(coords(isnan(coords(:,2)),2))
    end

    plot([point1_x; point2_x], [point1_y; point2_y], 'Color', color, 'LineWidth', linewidth);
    %saveas(gcf, "t.png")
% Local Variables:
% matlab-indent-level: 4
% End: