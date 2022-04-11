function [submap_indexes] = filter_divider(collicular_positions, divider, direction)
    x_predict = divider; % collicular_positions(:, 2) .* divider(1) + divider(2);
    if direction == "left"
        submap_indexes = x_predict < collicular_positions(:, 1);
    elseif direction == "right"
        submap_indexes = x_predict >= collicular_positions(:, 1);
    else
        disp("Check directional arguments (left/right)")
    end
end