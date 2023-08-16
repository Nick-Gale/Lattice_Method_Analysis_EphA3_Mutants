function h = Dplot_lattice_hjorth(so, object, plotting_dictionary, direction, h1, h2, varargin)
% DPLOT_LATTICE_HJORTH-  stripped down lattice plotting function from DPLOT_LATTICE_BASIC which is from DPLOT_LATTICE

%   Plot the lattice in DIRECTION into subplots with handles H1 and H2.
%   
%  %
%   The function accepts a number of options, specified as
%   name-argument pairs:
%
% 
%   - Subgraph: If true, plot only distributions around points in the
%       maximum subgraph; otherwise plot all distributions.
%
%   - Lattice: If true (default), print a Lattice.
%    
%   - LatticeColour: Colour of lattice. Defaults to black for
%       'FTOC' direction and blue for 'CTOF' direction
%
%
%   - AxisStyle: If 'crosshairs' (default), plot crosshairs and
%       scalebars (as in all figures in Willshaw et al. 2013). If
%    'box', plot conventional axes. If 'crosshairs' plot cross hairs and scale box. If %    'crosshairs_nobars' plot crosshairs only. If 'none', plot no axes.
%    
%    - HighStd: If true (default false) shows the points on the colliculus
%     with high standard deviations and the corresponding points on the retina.

%   --Orientation: If true (default false) three pairs of matching nasotemporally and rostrocaudally directed
%     orientation lines are drawn
%
%   - Outline: Whether to draw an outline around the field or
%       colliculus. Can be 'none' (default), 'field', 'colliculus', or
%       'both'.
%
%   - PointNumbers: If true (default false), print ids of points at
%       their respective locations.
%    
% See also: plot_angles, plot_superposed
    if (nargin > 4) 
        p = validateInput(varargin, {'Subgraph', 'HighStd', 'Lattice', 'LatticeColour', 'AxisStyle', 'Outline', 'Orientation', 'PointNumbers', 'Title'});
    else
        p = struct();
    end

    AxisStyle = check_arg(p, 'AxisStyle', {'crosshairs','crosshairs_nobars', 'box', 'none'});

    Subgraph = false; 
    if (isfield(p, 'Subgraph'))
        Subgraph = p.Subgraph;
    end

    HighStd = false;
    if isfield(p, 'HighStd')
        HighStd = p.HighStd;
    end
    
    Lattice = true;
    if isfield(p, 'Lattice')
        Lattice = p.Lattice;
    end

    if strcmp(direction, 'CTOF')
        LatticeColour = 'k'; % 'b'
    else
        LatticeColour = 'b'; % 'k'
    end
    if isfield(p, 'LatticeColour')
        LatticeColour = p.LatticeColour;
    end

    Orientation = false;
    if isfield(p, 'Orientation')
        Orientation = p.Orientation;
    end
    
    PointNumbers = false;
    if isfield(p, 'PointNumbers')
        PointNumbers = p.PointNumbers;
    end
    
    Outline = check_arg(p, 'Outline', {'none', 'field', 'colliculus', 'both'});
 
    Title = false;

    if isfield(p, 'Title')
       Title = p.Title;
    end
  

    % Clear axes
    subplot(h1)
    %cla
    subplot(h2)
    %cla

    % Plots out the numbers of each node so that anchors can be chosen easily.
    if (PointNumbers)
        num_points = object.numpoints;
        candidates = object.candidates;        
        takeout = object.takeout;
        from_coords = object.chosen;
        to_coords = object.projected;
        list_of_points = setdiff(candidates, takeout);

        subplot(h1)
        hold on
        for lop=1:length(list_of_points)
            text(from_coords(list_of_points(lop),1), from_coords(list_of_points(lop),2), num2str(list_of_points(lop)), 'FontSize', 8);
        end

        subplot(h2)
        hold on
        for lop=1:length(list_of_points)
            text(to_coords(list_of_points(lop),1), to_coords(list_of_points(lop),2), num2str(list_of_points(lop)), 'FontSize', 8);
        end
    end

    if (HighStd)
        %high_points = object.filtkered_points;
        if direction == 'CTOF'
            filtered_coll_coords = so.filtered_colliculus_CTOF;
            filtered_field_coords = so.filtered_field_CTOF;

            retained_coll_coords = so.retained_colliculus_CTOF;
            retained_field_coords = so.retained_field_CTOF;
        end
        if direction == 'FTOC'
            filtered_coll_coords = so.filtered_colliculus_FTOC;
            filtered_field_coords = so.filtered_field_FTOC;

            retained_coll_coords = so.retained_colliculus_FTOC;
            retained_field_coords = so.retained_field_FTOC;
        end
        subplot(h1);
        hold on
        scatter(filtered_coll_coords(:,1), filtered_coll_coords(:,2), 3, 'g')
        scatter(retained_coll_coords(:,1), retained_coll_coords(:,2), 1, [0.01, 0.01, 0.01], 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.1)
        
        subplot(h2);
        hold on 
        scatter(filtered_field_coords(:,1), filtered_field_coords(:,2), 3, 'g')
        scatter(retained_field_coords(:,1), retained_field_coords(:,2), 3, [0.01, 0.01, 0.01], 'MarkerFaceAlpha', 0.1, 'MarkerEdgeAlpha', 0.1)
    end


    % Plot lattice
    if (Lattice)
        if direction == 'CTOF' 
            field_coords = object.projected_points;
            coll_coords = object.chosen_points;
        end
        if direction == 'FTOC'
            coll_coords = object.projected_points;
            field_coords = object.chosen_points;
        end
        points_in_subgraph = object.points_in_subgraph;
        list_of_neighbours = object.list_of_neighbours;
        num_points = object.numpoints;
        sets_of_intersections = object.sets_of_intersections;
        points_not_in_subgraph = object.points_not_in_subgraph;
        xticks([0.0 0.5 1.0])
        
        
        % Lattice on Field
        subplot(h2)
        hold on
        % Full graph
        if (~Subgraph)
            print_links(1:num_points, field_coords, list_of_neighbours, LatticeColour);
            [cross_points,list_of_crossings] = make_cross_list(1:num_points, sets_of_intersections);
            print_links(cross_points, field_coords, list_of_crossings, 'r')
        else
            % Subgraph only
            print_links(points_in_subgraph, field_coords, list_of_neighbours, LatticeColour);
            plot(field_coords(points_not_in_subgraph, 1), field_coords(points_not_in_subgraph, 2), 'xr', 'MarkerSize', 3);
            [cross_points,list_of_crossings] = make_cross_list(points_in_subgraph, sets_of_intersections);
            print_links(cross_points, field_coords, list_of_crossings, 'r');
        end

        axis equal
        axis off

        % Lattice on Colliculus
        hold on
        subplot(h1)
        hold on
        if (~Subgraph)
            print_links(1:num_points, coll_coords, list_of_neighbours, LatticeColour);
            [cross_points,list_of_crossings] = make_cross_list(1:num_points, sets_of_intersections);
            print_links(cross_points, coll_coords, list_of_crossings, 'r');
        else
            print_links(points_in_subgraph, coll_coords, list_of_neighbours, LatticeColour);
            plot(coll_coords(points_not_in_subgraph,1), coll_coords(points_not_in_subgraph,2),'xr','MarkerSize',3);
            [cross_points, list_of_crossings] = make_cross_list(points_in_subgraph,sets_of_intersections);
            print_links(cross_points, coll_coords, list_of_crossings, 'r');
        end 
    end

    if (Orientation)
        coll_points = object.coll_chosen;
        field_points = object.field_chosen;
        plot_orientation(h1, h2, field_points, coll_points, [0.75 0.5 0.25]);
    end

    % Outline of field
    subplot(h2)
    if (strcmp(Outline, 'field') || strcmp(Outline, 'both'))
        X = object.field_data(:, 1);
        Y = object.field_data(:, 2);
        k = convhull(X, Y);
        plot(X(k), Y(k), 'k-');
    end
    
    % Outline of colliculus
    subplot(h1)
    if (strcmp(Outline, 'colliculus') || strcmp(Outline, 'both'))
        X = object.collicular_data(:, 1);
        Y = object.collicular_data(:, 2);
        k = convhull(X, Y);
        plot(X(k), Y(k), 'k-');
    end
    
    % Set axis properties for CTOF  Field plot (h2)
    subplot(h2)
    hold on
    switch(AxisStyle)
      case 'crosshairs'
        draw_crosshairs(plotting_dictionary);
        axis off
        draw_scalebar(plotting_dictionary)
      case 'crosshairs_nobars'
        draw_crosshairs(plotting_dictionary);
	    axis off
      case 'none'
        axis off
      case 'box'
        set(gca, 'FontSize', 16)
        axis on
      otherwise
        axis off
    end

    set_axis_props(plotting_dictionary); % there is a quirk with axis orientation in this function flipping only the y-axis
    set(gca, 'XDIR', 'reverse'); % set this for visual orientation rather than anatomical orientation
    set(gca, 'YDIR', 'normal'); % set this 'normal' for visual orientation rather than anatomical orientation.
    
    if Title
        title(plotting_dictionary.title);
    end
    axis on
    if isfield(plotting_dictionary, 'xlabel')
        xlabel(plotting_dictionary.xlabel);
    else
        xlabel('');
    end

    if isfield(plotting_dictionary, 'ylabel')
        ylabel(plotting_dictionary.ylabel);
    else
        xlabel('')
    end

    % Set axis properties for CTOF colliculus plot (h1) subplot(h2)
    subplot(h1)
    hold on
    switch(AxisStyle)
      case 'crosshairs'
        axis off
        draw_crosshairs(plotting_dictionary)
      case 'none'
        axis off
      case 'box'
        set(gca, 'FontSize', 16)
        axis on
      otherwise
        axis off
    end
    set_axis_props(plotting_dictionary);

    if Title
       title(plotting_dictionary.title);
    end

    axis on
    if isfield(plotting_dictionary, 'xlabel')
        xlabel(plotting_dictionary.xlabel);
    else
        xlabel('');
    end
    
    if isfield(plotting_dictionary, 'ylabel')
        ylabel(plotting_dictionary.ylabel);
    else
        ylabel('');
    end
end




   



