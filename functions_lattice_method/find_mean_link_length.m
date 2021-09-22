function [link_length_mean, link_length_std] = find_mean_link_length(list_of_neighbours, coords)
    first_point = coords(list_of_neighbours(:,1),:);
    second_point = coords(list_of_neighbours(:,2),:);
    dists = diag(compute_dist(first_point,second_point'));
    link_length_mean = mean(dists);
    link_length_std = std(dists);