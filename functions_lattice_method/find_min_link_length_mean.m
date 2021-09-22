function [min_link_length_mean, min_link_length_std] = find_min_link_length_mean(neighbours, coords)
    
    distances = compute_dist(coords,coords');
    distances = distances.*neighbours + (1-neighbours)*10000;
    min_link_lengths = min(distances);
    min_link_length_mean = mean(min_link_lengths);
    min_link_length_std = std(min_link_lengths);
    
    