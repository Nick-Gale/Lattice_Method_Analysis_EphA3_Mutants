% Anatomy plots dR
    %load the images 
    dr = [0.00, 0.31, 0.56, 0.81, 1.05, 1.30, 1.55];
    ratio = 0.50;
    g = 0;
    rep = 1;
    imvec = {};
    fig = [];
    titles = {"A", "B", "C", "D", "E", "F"};
    plot_title = 'A B C D E F';
    ordinals = '(1) \n  (2) \n (3) \n (4) \n (5) \n (6)';

    for i = 1:length(dr)
        filename = sprintf('./results_plots/figure_anatomy_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d).png', dr(i), ratio, g, rep);
        % imvec{i} = imread(filename, 'loose');
        fig = cat(2, fig, imread(filename));
    end
    imshow(fig)
    annotation('textbox', [0.13 0.03 0.8 0.1],...
                'String', titles)


    imwrite(fig, "./results_plots/paper_anatomy_dr.png")
% Anatomy plots dGamma

% Lattice Plots dR
fig = [];
fig1 = [];
fig2 = [];
fig3 = [];

bar_size = 5;
for i = 1:length(dr)
    filename1 = sprintf('./results_plots/figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d)_ANATOMY_FTOC.png', dr(i), ratio, g, rep);
    fig1 = cat(2, fig1, imread(filename1));
    L = size(fig1, 1);
    dividing_bar = zeros(L, bar_size, 3);

    size(dividing_bar);
    size(fig1);
    L;
    fig1 = cat(2, fig1, dividing_bar);

    filename2 = sprintf('./results_plots/figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d)_ANATOMY_CTOF.png', dr(i), ratio, g, rep);
    fig2 = cat(2, fig2, imread(filename2));
    L = size(fig2, 1);
    dividing_bar = zeros(L, bar_size, 3);
    fig2 = cat(2, fig2, dividing_bar);

    filename3 = sprintf('./results_plots/figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (%0.2f, %0.2f, %d, %d)_SCANNER_CTOF.png', dr(i), ratio, g, rep);
    fig3 = cat(2, fig3, imread(filename3));
    L = size(fig3, 1);
    dividing_bar = zeros(L, bar_size, 3);    
    fig3 = cat(2, fig3, dividing_bar);
end

% cat_append = ones(size(fig1, 1), abs(size(fig2, 2) - size(fig1, 2)), 3);
% fig1 = cat(2, fig1, cat_append);
% cat_append = ones(size(fig3, 1), abs(size(fig3, 2) - size(fig1, 2)), 3);
% fig3 = cat(2, fig3, cat_append);

L = size(fig1, 2);
dividing_bar = zeros(bar_size, L, 3);
fig1 = cat(1, fig1, dividing_bar);
fig2 = cat(1, fig2, dividing_bar);
fig3 = cat(1, fig3, dividing_bar);


fig = cat(1, fig, fig1);
fig = cat(1, fig, fig2);
fig = cat(1, fig, fig3);

fig = imresize(fig, 0.5);
imwrite(fig, "./results_plots/paper_lattice_plots.png")
