function [] = anatomy(obj, dict, plot_axes)
    % this function takes a super object and produces an image with six subplots: 
    % 1. Colour coded retinal location
    % 2. Colour coded gradients with two lines showing where slices in the DV axis are to be taken. Gradients are Eph in the retina and Eprhin in the colliculus - both the A system
    % 3. The average phase projection of all collicular cells within a threshold of slice ML
    % 4. The average anatomical projection of all collicular cells within a threshold of slice ML
    % 5. The average projection of epha3 and wt cell colour coded within a threshold slice DV
    % 6. The distribution of cells over the collicilus colour coded
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Load Data
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    collicular_positions_RC = obj.Biology.collicular_positions_RC;
    collicular_positions_ML = obj.Biology.collicular_positions_ML;
    retinal_positions_NT = obj.Biology.retinal_positions_NT;
    retinal_positions_DV = obj.Biology.retinal_positions_DV;
    ephA3_indexes = obj.Biology.ephA3;
    field_positions_NT = obj.Lattice.CTOF_full_field_positions(:,1);
    field_positions_DV = obj.Lattice.CTOF_full_field_positions(:,2);

    connections = obj.Biology.connections;
    weights = obj.Biology.weights;

    collicular_gradient = obj.Biology.SCephrinA;
    retinal_gradient = obj.Biology.RGCEphA;

    id = obj.id;
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Load Parameters
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    DV_slice_location = dict.DV;
    ML_slice_location = dict.ML;
    threshold = dict.threshold;

    wt_colour = dict.wt_colour;
    epha3_colour = dict.epha3_colour;
    inj_colour = dict.inj_colour;
    sc_colour = dict.sc_colour;
    transparency = dict.transparency;
    fs = dict.fontsize;
    markersize = dict.markersize;

    save_dir = strcat(dict.directory, sprintf('figure_anatomy_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d).png', id(1), id(2), id(3), id(4)));

    if plot_axes == 1
        figure_label = sprintf('Object ID (EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d)', id(1), id(2), id(3), id(4));

        subplot1_xlabel = dict.subplot1_xlabel;
        subplot1_ylabel = dict.subplot1_ylabel;

        subplot2_xlabel = dict.subplot2_xlabel;
        subplot2_ylabel = dict.subplot2_ylabel;

        subplot3_xlabel = dict.subplot3_xlabel;
        subplot3_ylabel = dict.subplot3_ylabel;

        subplot4_xlabel = dict.subplot4_xlabel;
        subplot4_ylabel = dict.subplot4_ylabel;

        subplot5_xlabel = dict.subplot5_xlabel;
        subplot5_ylabel = dict.subplot5_ylabel;
    elseif plot_axes == 0
        figure_label = sprintf('Object ID (EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d)', id(1), id(2), id(3), id(4));
        subplot1_xlabel = ''; % dict.subplot1_xlabel;
        subplot1_ylabel = '';

        subplot2_xlabel = dict.subplot2_xlabel;
        subplot2_ylabel = '';

        subplot3_xlabel = ''; % dict.subplot3_xlabel;
        subplot3_ylabel = '';

        subplot4_xlabel = '' % dict.subplot4_xlabel;
        subplot4_ylabel = '';

        subplot5_xlabel = ''; % dict.subplot5_xlabel;
        subplot5_ylabel = '';

        subplot6_xlabel = dict.subplot6_xlabel;
        subplot6_ylabel = '';
    else
        disp("Plot_axes should be logical (0/1)")
    end
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Create plotting data
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    L_c = length(collicular_positions_RC);
    L_r = length(retinal_positions_NT);
    retinal_collicular_connectivity = zeros(L_c, L_r);
    for i = 1:L_c
        indexes = connections(:, i);
        non_zero = indexes(indexes ~= 0);
        %colliculus indexes are in the rows, retinal connections are in the columns
        %retinal_collicular_connectivity(i, non_zero) = weights(indexes ~= 0);
        for j = 1:length(indexes)
            if indexes(j) > 0
                retinal_collicular_connectivity(i, indexes(j)) = retinal_collicular_connectivity(i, indexes(j)) + 1;
            end
        end
    end

    %indexes for subplots
    ephA3_indexes = ephA3_indexes;
    WT_indexes = setdiff(1:L_r, ephA3_indexes);
    dv_slice_indexes = find(((DV_slice_location - threshold) < retinal_positions_DV ) .* (retinal_positions_DV < (DV_slice_location + threshold)));
    ml_slice_indexes = find(((ML_slice_location - threshold) < collicular_positions_ML) .* (collicular_positions_ML < (ML_slice_location + threshold)));

    %colour coded retinal positions
    inj_x = dict.injection_location(1);
    inj_y = dict.injection_location(2);
    inj_r = dict.injection_radius;
    injection_indexes = sqrt((retinal_positions_NT - inj_x) .^ 2 + (retinal_positions_DV - inj_y) .^ 2) < inj_r;

    subplot1_ephA3_x = retinal_positions_NT(ephA3_indexes);
    subplot1_ephA3_y = retinal_positions_DV(ephA3_indexes);
    subplot1_WT_x = retinal_positions_NT(WT_indexes);
    subplot1_WT_y = retinal_positions_DV(WT_indexes);
    subplot1_inj_x = retinal_positions_NT(injection_indexes);
    subplot1_inj_y = retinal_positions_DV(injection_indexes);

    %colour coded gradients
    subplot2_ephA3_x = retinal_positions_NT(ephA3_indexes);
    subplot2_ephA3_y = retinal_gradient(ephA3_indexes);

    subplot2_WT_x = retinal_positions_NT(WT_indexes);
    subplot2_WT_y = retinal_gradient(WT_indexes);

    subplot2_ephrinA_x = 1 - collicular_positions_RC;
    subplot2_ephrinA_y = collicular_gradient;
    
    %sort these
    [subplot2_ephA3_x, sortperm_ephA3] = sort(subplot2_ephA3_x, 'ascend');
    subplot2_ephA3_y = subplot2_ephA3_y(sortperm_ephA3);

    [subplot2_WT_x, sortperm_WT] = sort(subplot2_WT_x, 'ascend');
    subplot2_WT_y = subplot2_WT_y(sortperm_WT);

    [subplot2_ephrinA_x, sortperm_ephrin] = sort(subplot2_ephrinA_x, 'ascend');
    subplot2_ephrinA_y = subplot2_ephrinA_y(sortperm_ephrin);

    %average phase projection from RC coliculus to NT retina within ML
    subplot3_x = collicular_positions_RC(ml_slice_indexes);
    subplot3_y = field_positions_NT(ml_slice_indexes);
    
    %average projection from NT retina to RC colliculus with labelled cell origins within DV;
    average_collicular_projection_RC = (collicular_positions_RC' * retinal_collicular_connectivity)' ./ sum(retinal_collicular_connectivity, 1)';
    average_collicular_projection_ML = (collicular_positions_ML' * retinal_collicular_connectivity)' ./ sum(retinal_collicular_connectivity, 1)';

    subplot4_EphA3_x = average_collicular_projection_RC(intersect(ml_slice_indexes, ephA3_indexes));
    subplot4_EphA3_y = retinal_positions_NT(intersect(ml_slice_indexes, ephA3_indexes));

    subplot4_WT_x = average_collicular_projection_RC(intersect(ml_slice_indexes, WT_indexes));
    subplot4_WT_y = retinal_positions_NT(intersect(ml_slice_indexes, WT_indexes));


    %distribution of contacts on colliculus with labelled origin
    subplot5_EphA3_x = average_collicular_projection_RC(ephA3_indexes);
    subplot5_EphA3_y = average_collicular_projection_ML(ephA3_indexes); 
   
    subplot5_WT_x = average_collicular_projection_RC(WT_indexes);
    subplot5_WT_y = average_collicular_projection_ML(WT_indexes);

    subplot5_inj_x = average_collicular_projection_RC(injection_indexes);
    subplot5_inj_y = average_collicular_projection_ML(injection_indexes);

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Plot
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
close all
fig = figure('Position', [0, 0, 400, 1600]);
%fig.WindowState = 'maximized';

%figure 1
    plt1 = subplot(7,1,2);
    scatter(subplot1_ephA3_x, subplot1_ephA3_y,  markersize, 'filled', 'MarkerEdgeColor', epha3_colour, 'MarkerFaceColor', epha3_colour);
    alpha(transparency);
    hold on;

    scatter(subplot1_WT_x, subplot1_WT_y,  markersize, 'filled', 'MarkerEdgeColor', wt_colour, 'MarkerFaceColor', wt_colour);
    alpha(transparency);
    hold on;

    scatter(subplot1_inj_x, subplot1_inj_y,  markersize, 'filled', 'MarkerEdgeColor', inj_colour, 'MarkerFaceColor', inj_colour);
    alpha(transparency * 2);


    % title(figure_label, 'FontSize', 4)
    subtitle(' ')
    xlabel(subplot1_xlabel, 'FontSize', fs);
    ylabel(subplot1_ylabel, 'FontSize', fs);
    line([0 1],[DV_slice_location DV_slice_location],'Color','k');
    set(gca, 'XDir', 'reverse');
    axis equal;
    axis([0 1 0 1]);
    set(gca, 'YTick', [0, 0.5, 1, 1.5])

%figure 2
    subplot(7,1,3)
    if ~isempty(subplot2_ephA3_y)
        gradients1 = plot(subplot2_ephA3_x, subplot2_ephA3_y, 'Color', epha3_colour,'LineWidth', lw);
    else
        gradients1 = plot(subplot2_WT_x, subplot2_WT_y, 'Color', epha3_colour, 'LineWidth', lw);
    end
    hold on
    gradients2 = plot(subplot2_WT_x, subplot2_WT_y, 'Color', wt_colour, 'LineWidth', lw);
    line([0 1], [max(subplot2_WT_y) max(subplot2_WT_y)],'LineStyle', '--', 'Color', wt_colour, 'LineWidth', lw);
    line([0 1], [1.5 1.5],'LineStyle', '--', 'Color', 'white', 'LineWidth', lw);
    hold on 
    gradients3 = plot(subplot2_ephrinA_x, subplot2_ephrinA_y, 'Color', sc_colour, 'LineWidth', lw);
    xlabel(subplot2_xlabel, 'FontSize', fs);
    ylabel(subplot2_ylabel, 'FontSize', fs);
    set(gca, 'XDir','reverse');
    if plot_axes == 1
        legend([gradients1 gradients2 gradients3],{'EphA3+','WT','Colliculus'},'Location','northeast','FontSize', fs * 0.5);
    end
    xlim([0,1]);
    ylim([0,1.5]);
    axis('square')

%figure 3
    subplot(7,1,4)
    scatter(subplot3_x, subplot3_y, 'filled', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'k');
    alpha(transparency);
    xlabel(subplot3_xlabel, 'FontSize', fs);
    ylabel(subplot3_ylabel, 'FontSize', fs);
    set(gca, 'YDir','reverse');
    axis equal;
    axis([0 1 0 1]);
    set(gca, 'YTick', [0, 0.5, 1, 1.5]);

%figure 4
    subplot(7,1,5);
    scatter(subplot4_EphA3_x, subplot4_EphA3_y, 'filled', 'MarkerEdgeColor', epha3_colour, 'MarkerFaceColor', epha3_colour);
    alpha(transparency);
    hold on;

    scatter(subplot4_WT_x, subplot4_WT_y, 'filled', 'MarkerEdgeColor', wt_colour, 'MarkerFaceColor', wt_colour);
    alpha(transparency);

    xlabel(subplot4_xlabel, 'FontSize', fs);
    ylabel(subplot4_ylabel, 'FontSize', fs);
    set(gca, 'YDir','reverse');
    axis equal;
    axis([0 1 0 1]);
    set(gca, 'YTick', [0, 0.5, 1, 1.5]);

%figure 5
    subplot(7,1,6)
    scatter(subplot5_EphA3_x, subplot5_EphA3_y, markersize,  'filled', 'MarkerEdgeColor', epha3_colour, 'MarkerFaceColor', epha3_colour);
    alpha(transparency);
    hold on

    scatter(subplot5_WT_x, subplot5_WT_y, markersize,  'filled', 'MarkerEdgeColor', wt_colour, 'MarkerFaceColor', wt_colour);
    alpha(transparency);
    hold on

    scatter(subplot5_inj_x, subplot5_inj_y, markersize, 'filled', 'MarkerEdgeColor', inj_colour, 'MarkerFaceColor', inj_colour);
    alpha(transparency * 2)

    line([0 1],[ML_slice_location ML_slice_location],'Color','k');

    xlabel(subplot5_xlabel, 'FontSize', fs);
    ylabel(subplot5_ylabel, 'FontSize', fs);
    axis equal;
    set(gca, 'YTick', [0, 0.5, 1, 1.5]);

%put a line between subplots 2 and 3. This is where the axes change from retinal on x to retinal on y
annotation('line', [0.25 0.75], [0.572 0.572], 'Color', 'k', 'LineWidth', 2);

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Save
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
orient tall;
axis tight; 

%print(save_dir,'-dpng');
exportgraphics(fig, save_dir, 'Resolution', 300);



