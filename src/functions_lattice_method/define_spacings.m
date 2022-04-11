function [npoints, obj_radius, lower_mean_min_spacing, upper_mean_min_spacing] = define_spacings(N, spacing_points_fraction, spacing_radius_multiplier, spacing_upper_bound, spacing_lower_bound);
    npoints = round(spacing_points_fraction * N);					
    obj_radius = sqrt(spacing_radius_multiplier / N);
    
    % Tolerance allowed - same as for experiments - 5.9->6.2 +/- 16%
    lower_mean_min_spacing = spacing_lower_bound * obj_radius;
    upper_mean_min_spacing = spacing_upper_bound * obj_radius;