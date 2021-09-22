function [] = plot_statistics(stats_vector, gradients, ratios, beta2, repeats)

sz = [length(gradients), length(ratios), length(beta2), length(repeats)];
L = prod(sz);

%  ratio of whole map vs largest ordered submap, ratio = 0.4
submap_ratio_beta2_off = zeros(length(gradients), length(repeats));
for u = 1:length(gradients)
    for s = 1:length(repeats)
        for t = 1:length(ratios)
            for v = 1:length(beta2)
                ind = sub2ind(sz, u, t, v, s);
                stats = stats_vector{ind};
                submap_ratio_beta2(u, s) = stats(11);
            end
        end
    end
end

% plot submap ratios
figure(1);
mean_submap_ratio_beta2 = mean(submap_ratio_beta2, 2);
error_submap_ratio_beta2 = std(submap_ratio_beta2')'; %note the transpose because Matlab does not have consistent grammar
confidence_submap_ratio_beta2 = error_submap_ratio_beta2 * tinv(0.975, length(gradients)-1);

hold on
ciplot(mean_submap_ratio_beta2 - confidence_submap_ratio_beta2, mean_submap_ratio_beta2 + confidence_submap_ratio_beta2, gradients, 'red');
alpha(0.2);
xlabel('Magnitude of EphA3-Ilset2 knock-in');
title('Largest Ordered Submap Ratio for varying EphA3 knock-in');
saveas(gcf, 'results_plots/stats_largest_ordered_submap_ratio.png');
hold off;

close(1);
