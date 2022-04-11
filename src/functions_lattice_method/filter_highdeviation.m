function [full_field_filtered, full_collicular_filtered, retained_indexes, filtered_indexes, standard_deviations] = filter_highdeviation(full_field_positions, full_collicular_positions, threshold, radius, direction)

if direction == "CTOF"
    distances = dist(full_collicular_positions');
    f = full_field_positions;
end
if direction == "FTOC"
    distances = sqrt((full_collicular_positions(:,1) - full_collicular_positions(:,1)') .^ 2 + (full_collicular_positions(:,2) - full_collicular_positions(:,2)') .^ 2);
    f = full_collicular_positions;
end

standard_deviations = zeros(size(f(:,1)));
for i = 1:length(standard_deviations)
    inds = find(distances(i,:) < radius);
    mean_f = mean(f(inds, :));
    f_dist_sq = dist(mean_f, f(inds, :)') .^ 2;
    standard_deviations(i) = sqrt(mean(f_dist_sq));
end

retained = standard_deviations < threshold;

% record which indexes are lost
filtered_indexes = [];
filtered_indexes = find(~retained);
retained_indexes = find(retained);

%output filtered positions
full_field_filtered = full_field_positions(retained_indexes, :);
full_collicular_filtered = full_collicular_positions(retained_indexes, :);

%let the user know what happened
display(strjoin([direction, '- Number of points left after filtering at ', num2str(threshold), ': ', num2str(size(retained_indexes, 1))]));

