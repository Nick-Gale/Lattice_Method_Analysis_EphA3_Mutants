function [] = activity_phase_plot(collicular_positions, bulk_activity, phases, plot_title, filename)

%make plots of the bulk activity and phase data
%check that axes are correctly aligned
x_vals = collicular_positions(:, 1);
y_vals = collicular_positions(:, 2);

activity_plot = figure;
scatter(x_vals, y_vals, [], bulk_activity, 'filled');
colormap(gray);
xlabel('Anterior-Posterior');
ylabel('Lateral-Medial');
title(strcat("Activity: ", plot_title));
saveas(activity_plot, strcat(filename, '_activity.png'));

phase_plot = figure;
scatter(x_vals, y_vals, [], phases, 'filled');
%set(phase_plot, 'SizeData', 90)
colormap(jet);
colorbar;
xlabel('Anterior-Posterior');
ylabel('Lateral-Medial');
title(strcat("Phase: ", plot_title));
saveas(phase_plot, strcat(filename, "_phase.png"));

%close all
end

