% ranges
dr = [0.00, 0.8, 1.2, 2.0, 4.0]; % [0, 0.8, 1.2, 1.6, 4.0]; %  [0.00, 0.4, 0.8, 1.2, 1.6, 2.0];
gamma = [0.001, 0.00625, 0.01];
ratios = [0.4, 0.5, 0.6];

%instances
epha3 = 2.0;
r = 0.50;
g = 0.00625;
rep = 1;

% parameters
bar_size = 5;


fig1 = [];
fig2 = [];
titles1 = {};
titles2 = {};
titles = {"A", "B", "C", "D", "E", "F", "G", "H"};
% for i = 1:length(dr)
%         titles1{i} =sprintf('DR = %0.2f', dr(i));
%         titles2{i} = sprintf('DR = %0.2f', dr(length(dr)/2+i));
% end

%% hard-coded
titles1 = {'A: DR = 0.0', 'B: DR = 0.22','C: DR = 0.34','D: DR = 0.56'};
titles2 = {'E: DR = 1.12', 'F: DR = 0.22', 'G: DR = 0.34','H: DR = 0.56'};

for i = 1:length(dr)
        if i == 1
            filename1 = sprintf('./results_plots/figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d)_SCANNER_FTOC.png', dr(i), r, g, rep);
            fig1 = cat(2, fig1, imread(filename1));
        elseif i <= 4
            filename1 = sprintf('./results_plots/figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d)_SCANNER_CTOF.png', dr(i), r, g, rep);
            fig1 = cat(2, fig1, imread(filename1));
        end
        if i == 1
            filename2 = sprintf('./results_plots/figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d)_SCANNER_FTOC.png', dr(end), r, g, rep);
            fig2 = cat(2, fig2, imread(filename2));
        elseif i <= 4
            filename2 = sprintf('./results_plots/figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d)_SCANNER_FTOC.png', dr(i), r, g, rep);
            fig2 = cat(2, fig2, imread(filename2));
        end
end


fig = cat(1, fig1, fig2);

w=3200;
h=1800;
figure
%fig = insertText(fig, [0.075 * w 0.01 * h; 0.45 * w 0.01 * h; 0.8 * w 0.01 * h; 1.175 * w 0.01 * h;], titles1, 'TextColor','black', 'FontSize', 100, 'BoxColor', 'white');
%fig = insertText(fig, [0.075 * w 0.95 * h; 0.45 * w 0.95 * h; 0.8 * w 0.95 * h; 1.175 * w 0.95 * h;], titles2, 'TextColor','black', 'FontSize', 100, 'BoxColor', 'white');
imwrite(fig, "./results_plots/paper_nonlinearantomy.png")