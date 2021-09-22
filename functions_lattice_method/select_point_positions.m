function [chosen, area, min_spacing, used_hist, use_mean, use_max] = select_point_positions(lower_mean_min_spacing, upper_mean_min_spacing, full_x, full_y, numpoints, min_points, radius, max_trial_scale_factor, min_spacing_fraction, min_spacing_reduction_factor, area_scaling, random_seed)
mean_min_spacing = 0;
num_potential_points = length(full_x);
x_active = full_x;
y_active = full_y;
if ~isempty(full_x);
    [~,area] = convhull(full_x, full_y);
else
    area = 0.00001;
end

reverseStr = [];

while mean_min_spacing < lower_mean_min_spacing
    x_active = full_x;
    y_active = full_y;
    if ~isempty(full_x);
        [~,area] = convhull(full_x, full_y);
    else
        area = 0.00001;
    end
    %------------------------------------------------------------------------
    % set the starting minimum spacing "min_spacing" according to the number of points required "numpoints" also set the number of iterations tried at this spacing "max_trials"

    min_spacing = min_spacing_fraction * sqrt(area / numpoints);
    max_trials = numpoints * max_trial_scale_factor;
    rand('twister', random_seed);
    num_points_selected = 0;

    %------------------------------------------------------------------------
    while num_points_selected < numpoints
        %------------------------------------------------------------------------
        %coordinates of points chosen contained in "chosen", resets at the beginning of each loop
        chosen = zeros(numpoints, 2);
        
        %here is the step where the min_spacing is reduced
        min_spacing = min_spacing_reduction_factor * min_spacing;
        %num_points_selected = 0;
        ntry = 0;

        %------------------------------------------------------------------------
        %"potential_points_x" and "potential_points_y" hold the coordinates of all the points that can be selected from
        potential_points_x = full_x;
        potential_points_y = full_y;
        num_potential_points = size(potential_points_x, 1);
        
       %------------------------------------------------------------------------
        %if the required number of points have not yet been chosen and the number of trials allowed is not exceeded and there are still some points to be chosen from then choose a new point
        while num_points_selected < numpoints && ntry <= max_trials && num_potential_points > 0
            chosen_point = round(rand*(num_potential_points-1))+1;
            x_chosen = potential_points_x(chosen_point);
            y_chosen = potential_points_y(chosen_point);

            %------------------------------------------------------------------------
            % The min_points test "chosen_point" gives the index of the chosen point "x_chosen" and" y_chosen" are its coordinates
            distance_from_chosen_point = sqrt((x_chosen - full_x).^2 + (y_chosen - full_y).^2);
            
            % Check there are enough active points within the radius with chosen centre
            num_active_within_radius = sum(distance_from_chosen_point <= radius);
            if num_active_within_radius < min_points
                potential_points_x(chosen_point) = [];
                potential_points_y(chosen_point) = [];
                num_potential_points = num_potential_points - 1;
                continue
            end

            num_points_selected = num_points_selected + 1;
            chosen(num_points_selected, 1) = x_chosen;
            chosen(num_points_selected, 2) = y_chosen;

            %------------------------------------------------------------------------
            %now select all the points within a distance of <min_spacing>  of the chosen point and remove mention of them from "potential_points_x" and "potential_points_y"
            distance_from_chosen = sqrt((potential_points_x - x_chosen).^2 + (potential_points_y - y_chosen).^2);
            points_in_radius = find(distance_from_chosen <= min_spacing);
            potential_points_x(points_in_radius) = [];
            potential_points_y(points_in_radius) = [];
            num_points_in_radius = length(points_in_radius);
            num_potential_points = num_potential_points - num_points_in_radius;
            %then go back and find another point
        end

        %if a satisfactory set of points have not been chosen decrease min_spacing and start again
    end
    %------------------------------------------------------------------------
    [~, sort_index] = sort(chosen(:,1));
    chosen = chosen(sort_index,:);

    %calculate area covered by chosen points
    % if unique(chosen(:,1)) > 3
    %     [~, area] = convhull(chosen(:,1),chosen(:,2));
    % else
    %     disp("warning: not enought points for convex hull")
    % end

    %compute some statistics 
    %Find out how often points belong to centres
    used_inds = zeros(size(x_active));
    for i=1:size(chosen, 1)
        within_radius = find_within_radius(chosen(i,:), radius, [full_x, full_y]);
        used_inds(within_radius) = used_inds(within_radius) + 1;
    end
    used_hist = hist(used_inds, 0:20);
    use_mean = mean(used_inds);
    use_max  = max(used_inds);
    
    %set the mean min spacing for looping
    choose_dists = compute_dist(chosen');
    choose_dists = choose_dists + max(max(choose_dists))*eye(numpoints);
    mean_min_spacing = mean(min(choose_dists))*numpoints/(numpoints-1);

    %print a status to let the user know what is going on
    if mean_min_spacing < lower_mean_min_spacing
        msg = sprintf(['Numpoints= ', num2str(numpoints), '. Node spacing= ', num2str(mean_min_spacing),' too low']);
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
        % disp();
    end

    if mean_min_spacing > upper_mean_min_spacing
        msg = sprintf(['Numpoints= ', num2str(numpoints), '. Node spacing= ', num2str(mean_min_spacing),' too high']);
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
    end

      
    if mean_min_spacing  >= lower_mean_min_spacing && mean_min_spacing <= upper_mean_min_spacing 
        msg = sprintf(['Numpoints= ', num2str(numpoints), '. Node spacing= ', num2str(mean_min_spacing),' within bounds']);
        fprintf([reverseStr, msg]);
        reverseStr = repmat(sprintf('\b'), 1, length(msg));
    end

    numpoints = numpoints - 1;
end


