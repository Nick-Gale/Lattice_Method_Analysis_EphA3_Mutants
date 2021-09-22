function [CTOF_full_field_filtered, CTOF_full_collicular_filtered, FTOC_full_field_filtered, FTOC_full_collicular_filtered] = uniquify_point_positions(CTOF_full_field_filtered, CTOF_full_collicular_filtered, FTOC_full_field_filtered, FTOC_full_collicular_filtered, noise_parameter)
% Ensure all point positions are unique by adding a small random number to all points.

% Test for non-unique rows
F_points_vector = {CTOF_full_field_filtered, CTOF_full_collicular_filtered, FTOC_full_field_filtered, FTOC_full_collicular_filtered};
U_points_vector = {};% [CTOF_full_field_filtered, CTOF_full_collicular_filtered, FTOC_full_field_filtered, FTOC_full_collicular_filtered]

for i = 1:length(F_points_vector)
    if (size(unique(sortrows(F_points_vector{i}), 'rows'), 1) ~=  size(F_points_vector{i}, 1)) 
        F_i = F_points_vector{i};
        xrange = max(F_i(:,1)) - min(F_i(:,1));
        yrange = max(F_i(:,2)) - min(F_i(:,2));
        k = min(xrange, yrange) * noise_parameter;
        U_points_vector{i} = F_i + k * (rand(size(F_i)) - 0.5);
    else
        U_points_vector{i} = F_points_vector{i};
    end
end

% Output
CTOF_full_field_filtered = U_points_vector{1};
CTOF_full_collicular_filtered = U_points_vector{2};
FTOC_full_field_filtered = U_points_vector{3};
FTOC_full_collicular_filtered = U_points_vector{4};