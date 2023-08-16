
% ranges
dr = [0.00, 0.8, 1.2, 2.0];

gamma = [0.000625, 0.001, 0.00625, 0.01, 0.0625] + eps(1);
ratios = [0.4, 0.5, 0.6];

%instances
epha3 = 2.0;
r = 0.50;
g = 0.00625;
rep = 1;

% parameters
dim1 = 4177;
dim2 = 3996;
whitespace = 1200;
bar_size = 15;


%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Lattice Anatomy Comparions
%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fig = [];
fig1 = [];
fig2 = [];


for i = 1:length(dr);
    if i == 1
        filename1 = sprintf('./results_plots/generated_plots/figure_submaps_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d)_SCANNER_CTOF.png', 4.0, r, g, rep);
    else
        filename1 = sprintf('./results_plots/generated_plots/figure_submaps_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d)_SCANNER_FTOC.png', dr(i), r, g, rep);
    end

    temp = imread(filename1);
    temp = temp(1:dim1,1:dim2,:);


    fig1 = cat(2, fig1, temp);
    fig1 = padarray(fig1, [0, whitespace, 0], 255, 'post');

    filename2 = sprintf('./results_plots/generated_plots/figure_submaps_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d)_SCANNER_CTOF.png', dr(i), r, g, rep);
    temp = imread(filename2);
    temp = temp(1:dim1,1:dim2,:);


    fig2 = cat(2, fig2, temp);
    fig2 = padarray(fig2, [0, whitespace, 0], 255, 'post');
end

fig2 = padarray(fig2, [0, size(fig1,2) - size(fig2, 2),0], 0, 'pre');
fig1 = padarray(fig1, [whitespace, 0, 0], 255, 'pre');


fig = cat(1, fig, fig2);
fig = cat(1, fig, fig1);

spacer = dim2 + whitespace;
inds = dim2 + whitespace/2:spacer:size(fig,2);
for i = 1:size(inds,2)
    fig(:, inds(i):inds(i)+bar_size, :) = 0;
end

ind = dim1 + whitespace/2;
fig(ind:ind+bar_size, 1:(dim2+whitespace/2), :) = 0;
fig(:, end-whitespace:end,:) = [];

fig = imresize(fig, 0.25);
imwrite(fig, "./results_plots/stitched_plots/paper_lattice_plots.png")