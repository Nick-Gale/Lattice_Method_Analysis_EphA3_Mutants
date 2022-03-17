% ranges
dr = [0.00, 0.4, 0.8, 1.2, 1.6, 2.0]; % [0, 0.8, 1.2, 1.6, 4.0]; %  [0.00, 0.4, 0.8, 1.2, 1.6, 2.0];
gamma = [0.001, 0.00625, 0.01];
ratios = [0.4, 0.5, 0.6];

%instances
epha3 = 2.0;
r = 0.50;
g = 0.00625;
rep = 1;

% parameters
bar_size = 5;


%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% FTOC Lattice Scanner Plots dR
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fig1 = [];
fig2 = [];
titles1 = {};
titles2 = {};
for i = 1:length(dr)/2
        titles1{i} =sprintf('ΔR = %0.2f', dr(i) / 3.54);
        titles2{i} = sprintf('ΔR = %0.2f', dr(length(dr)/2+i) / 3.54);
end

for i = 1:length(dr)/2
        filename1 = sprintf('./results_plots/figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d)_SCANNER_FTOC.png', dr(i), r, g, rep);
        fig1 = cat(2, fig1,  imread(filename1));
        L = size(fig1, 1);
        dividing_bar = zeros(L, bar_size, 3);
        fig1 = cat(2, fig1, dividing_bar);

        filename2 = sprintf('./results_plots/figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d)_SCANNER_FTOC.png', dr(length(dr)/2+i), r, g, rep);
        fig2 = cat(2, fig2, imread(filename2));
        L = size(fig2, 1);
        dividing_bar = zeros(L, bar_size, 3);
        fig2 = cat(2, fig2, dividing_bar);
end
L = size(fig1, 2);
dividing_bar = zeros(bar_size, L, 3);
fig1 = cat(1, fig1, dividing_bar);
fig2 = cat(1, fig2, dividing_bar);
fig = cat(1, fig1, fig2);
fig = cat(1, dividing_bar, fig);
fig = cat(1, fig, dividing_bar);
L = size(fig, 1);
dividing_bar = zeros( L, bar_size, 3);
fig = cat(2, fig, dividing_bar);
fig = cat(2, dividing_bar, fig);

w=3200;
h=1800;
figure
fig = insertText(fig, [0.1 * w 0.01 * h; 0.5 * w 0.01 * h; 0.9 * w 0.01 * h; ], titles1, 'TextColor','black', 'FontSize', 50, 'BoxColor', 'white');

fig = insertText(fig, [0.1 * w 0.95 * h; 0.5 * w 0.95 * h; 0.9 * w 0.95 * h; ], titles2, 'TextColor','black', 'FontSize', 50, 'BoxColor', 'white');
imwrite(fig, "./results_plots/thesis_FTOC_lattice_plots.png")

%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% CTOF Lattice Scanner Plots dR
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fig1 = [];
fig2 = [];
titles1 = {};
titles2 = {};
for i = 1:length(dr)/2
        titles1{i} =sprintf('ΔR = %0.2f', dr(i) / 3.54);
        titles2{i} = sprintf('ΔR = %0.2f', dr(length(dr)/2+i) / 3.54);
end

for i = 1:length(dr)/2
        filename1 = sprintf('./results_plots/figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d)_SCANNER_CTOF.png', dr(i), r, g, rep);
        fig1 = cat(2, fig1,  imread(filename1));
        L = size(fig1, 1);
        dividing_bar = zeros(L, bar_size, 3);
        fig1 = cat(2, fig1, dividing_bar);

        filename2 = sprintf('./results_plots/figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d)_SCANNER_CTOF.png', dr(length(dr)/2+i), r, g, rep);
        fig2 = cat(2, fig2, imread(filename2));
        L = size(fig2, 1);
        dividing_bar = zeros(L, bar_size, 3);
        fig2 = cat(2, fig2, dividing_bar);
end
L = size(fig1, 2);
dividing_bar = zeros(bar_size, L, 3);
fig1 = cat(1, fig1, dividing_bar);
fig2 = cat(1, fig2, dividing_bar);
fig = cat(1, fig1, fig2);
fig = cat(1, dividing_bar, fig);
fig = cat(1, fig, dividing_bar);
L = size(fig, 1);
dividing_bar = zeros( L, bar_size, 3);
fig = cat(2, fig, dividing_bar);
fig = cat(2, dividing_bar, fig);

w=3200;
h=1800;
figure
fig = insertText(fig, [0.1 * w 0.01 * h; 0.5 * w 0.01 * h; 0.9 * w 0.01 * h; ], titles1, 'TextColor','black', 'FontSize', 50, 'BoxColor', 'white');

fig = insertText(fig, [0.1 * w 0.95 * h; 0.5 * w 0.95 * h; 0.9 * w 0.95 * h; ], titles2, 'TextColor','black', 'FontSize', 50, 'BoxColor', 'white');
imwrite(fig, "./results_plots/thesis_CTOF_lattice_plots.png")
