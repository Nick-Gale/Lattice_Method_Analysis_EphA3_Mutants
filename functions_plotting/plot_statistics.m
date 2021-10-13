function [] = plot_statistics(stats_vector, gradients, ratios, beta2, repeats)

sz = [length(gradients), length(ratios), length(beta2), length(repeats)];
L = prod(sz);

b_width = 0.1;
disp_factor = 0.5;
alp = 0.05;

%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% visual field overlap of the two part maps (CTOF)
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    st = zeros(length(gradients), length(repeats));
    for u = 1:length(gradients)
        for s = 1:length(repeats)
            for t = 1:length(ratios)
                for v = 1:length(beta2)
                    ind = sub2ind(sz, u, t, v, s);
                    stats = stats_vector{ind};
                    st(u, s) = stats(33);
                end
            end
        end
    end

    % plot submap ratios
    figure(5);
    hold on
    for i=1:length(gradients)
        dispersion = gradients(i)*ones(size(st(i,:))) + disp_factor * b_width * (0.5 - rand(size(st(i,:))));
        scatter(dispersion, st(i,:), 10, 'filled', 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [1,1,1])
        boxchart(gradients(i)*ones(size(st(i,:))), st(i,:), 'JitterOutliers', 'off', 'SeriesIndex', 4, 'BoxWidth', b_width)
    end
    xlim([gradients(1) - b_width, gradients(length(gradients)) + b_width])
    alpha(alp);
    xlabel('Magnitude of EphA3-Ilset2 knock-in');
    ylabel('Overlap Fraction');
    title('Visual Field Overlap of C-to-F Part-Maps');
    saveas(gcf, 'results_plots/stats_largest_vfo.png');
    hold off
    close(5);

%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% collicular overlap of the two part maps (FTOC)
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    st = zeros(length(gradients), length(repeats));
    for u = 1:length(gradients)
        for s = 1:length(repeats)
            for t = 1:length(ratios)
                for v = 1:length(beta2)
                    ind = sub2ind(sz, u, t, v, s);
                    stats = stats_vector{ind};
                    st1(u, s) = stats(81);
                    st2(u, s) = stats(82);
                end
            end
        end
    end
    % plot submap ratios
    figure(5);
    hold on
    for i=1:length(gradients)

        dispersion = gradients(i)*ones(size(st(i,:))) + disp_factor * b_width * (0.5 - rand(size(st(i,:))));
        scatter(dispersion, st1(i,:), 10, 'filled', 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [1,1,1])
        boxchart(gradients(i)*ones(size(st(i,:))), st1(i,:), 'JitterOutliers', 'off', 'SeriesIndex', 1, 'BoxWidth', b_width)

        dispersion = gradients(i)*ones(size(st(i,:))) + disp_factor * b_width * (0.5 - rand(size(st(i,:))));
        scatter(dispersion, st2(i,:), 10, 'filled', 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [1,1,1])
        boxchart(gradients(i)*ones(size(st(i,:))), st2(i,:), 'JitterOutliers', 'off', 'SeriesIndex', 2, 'BoxWidth', b_width)
    end
    xlim([gradients(1) - 0.1, gradients(length(gradients)) + 0.1])
    mi = min([min(st2'), min(st1')]);
    ma = max([max(st2'), max(st1')]);
    ylim([mi, ma]);
    alpha(alp);
    xlabel('Magnitude of EphA3-Ilset2 knock-in');
    ylabel('Overlap Fraction');
    title('Collicular Overlap of F-to-C Part-Maps');
    saveas(gcf, 'results_plots/stats_largest_co.png');
    hold off
    close(5)




%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Map quality of C-to-F
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    st = zeros(length(gradients), length(repeats));
    for u = 1:length(gradients)
        for s = 1:length(repeats)
            for t = 1:length(ratios)
                for v = 1:length(beta2)
                    ind = sub2ind(sz, u, t, v, s);
                    stats = stats_vector{ind};
                    st(u, s) = stats(5);
                end
            end
        end
    end

    % plot submap ratios
    figure(5);
    hold on
    for i=1:length(gradients)
        dispersion = gradients(i)*ones(size(st(i,:))) + disp_factor * b_width * (0.5 - rand(size(st(i,:))));
        scatter(dispersion, st(i,:), 10, 'filled', 'MarkerFaceColor', [0 0 0], 'MarkerEdgeColor', [1,1,1])
        boxchart(gradients(i)*ones(size(st(i,:))), st(i,:), 'JitterOutliers', 'off', 'SeriesIndex', 3, 'BoxWidth', b_width)
    end
    xlim([gradients(1) - b_width, gradients(length(gradients)) + b_width])
    alpha(alp);
    xlabel('Magnitude of EphA3-Ilset2 knock-in');
    ylabel('Quality Percetange');
    title('Map Quality C-to-F');
    saveas(gcf, 'results_plots/stats_ctof_quality.png');
    hold off
    close(5);


    %%%%%%%%%%%%%%%%%%%%%%
    % mean_st = mean(st, 2);
    % error_st = std(st')'; %note the transpose because Matlab does not have consistent grammar
    % confidence_st = error_st * tinv(0.975, length(gradients)-1);
    % plot(gradients, mean_st);
    % ciplot(mean_st - confidence_st, mean_st + confidence_st, gradients, 'red');