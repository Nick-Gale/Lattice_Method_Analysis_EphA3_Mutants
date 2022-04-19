% ranges
dr = [0.00, 0.4, 0.8, 1.2, 1.6, 2.0];
gamma = [0.000625, 0.001, 0.00625, 0.01, 0.0625] + eps(1);
ratios = [0.4, 0.5, 0.6];

%instances
epha3 = 2.0;
r = 0.50;
g = 0.00625;
rep = 1;

% parameters
bar_size = 5;

%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Anatomy plots dR
%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    %load the images 
        fig = [];
        titles = {"A", "B", "C", "D", "E", "F"};
        plot_title = 'A B C D E F';
        ordinals = '(1) \n  (2) \n (3) \n (4) \n (5) \n (6)';

        for i = 1:length(dr)
            filename = sprintf('./results_plots/generated_plots/figure_anatomy_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d).png', dr(i), r, g, rep);
            fig = cat(2, fig, imread(filename));
        end
        imshow(fig)
        annotation('textbox', [0.13 0.03 0.8 0.1],'String', titles)


        imwrite(fig, "./results_plots/stitched_plots/paper_anatomy_dr.png", 'png')
%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Anatomy plots Activity
%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    for j = 1:length(gamma)
    %load the images 
        fig = [];
        titles = {"A", "B", "C", "D", "E", "F"};
        plot_title = 'A B C D E F';
        ordinals = '(1) \n  (2) \n (3) \n (4) \n (5) \n (6)';

        for i = 1:length(dr)
            filename = sprintf('./results_plots/generated_plots/figure_anatomy_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %e, %d).png', dr(i), r, gamma(j), rep);
            fig = cat(2, fig, imread(filename));
        end
        imshow(fig)
        annotation('textbox', [0.13 0.03 0.8 0.1], 'String', titles)


        imwrite(fig, sprintf('./results_plots/stitched_plots/paper_anatomy_dr_gamma=%f.png', gamma(j)), 'png')
    end
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% Anatomy plots dBeta2
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     %load the images 
     fig = [];
     titles = {"A", "B", "C", "D", "E", "F"};
     plot_title = 'A B C D E F';
     ordinals = '(1) \n  (2) \n (3) \n (4) \n (5) \n (6)';

    for i = 1:length(dr)
         filename = sprintf('./results_plots/generated_plots/figure_anatomy_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d).png', dr(i), r, 1, rep);
         fig = cat(2, fig, imread(filename));
    end
     imshow(fig)
     annotation('textbox', [0.13 0.03 0.8 0.1], 'String', titles)


     imwrite(fig, "./results_plots/stitched_plots/paper_anatomy_dr_beta2.png")

%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%Lattice Scanner Plots dR
%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    fig = [];
    fig1 = [];
    fig2 = [];

    for i = 1:length(dr)
        filename1 = sprintf('./results_plots/generated_plots/figure_submaps_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d)_SCANNER_FTOC.png', dr(i), r, g, rep);
        fig1 = cat(2, fig1, imread(filename1));
        L = size(fig1, 1);
        filename2 = sprintf('./results_plots/generated_plots/figure_submaps_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d)_SCANNER_CTOF.png', dr(i), r, g, rep);
        
        if i == 1
            fig2 = cat(2, fig2, imread(filename2));
            L = size(fig2, 1);  
        elseif size(imread(filename2),2) == size(fig2,2)
            fig2 = cat(2, fig2, imread(filename2));
            L = size(fig2, 1);
        else
            i 
            temp = imread(filename2);
            size(fig2)
            size(temp)

            size(fig2,2) - size(temp, 2)
            temp = padarray(temp, [0,size(fig2,2) - size(temp, 2),0], 0, 'pre');
            fig2 = cat(2, fig2, temp);
            L = size(fig2, 1);
        end


    end

    L = size(fig1, 2);


    fig = cat(1, fig, fig2);
    fig = cat(1, fig, fig1);

    fig = imresize(fig, 0.5);
    imwrite(fig, "./results_plots/stitched_plots/paper_lattice_plots.png")

%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Lattice Anatomy Comparions
%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    fig = [];
    fig1 = [];
    fig2 = [];
    fig3 = [];
    fig4 = [];

    bar_size = 5;
    filename1 = sprintf('./results_plots/generated_plots/figure_wholemaps_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d)_ANATOMY_FTOC.png', epha3, r, g, rep);
    fig1 = cat(2, fig1, imread(filename1));
    L = size(fig1, 1);
    dividing_bar = zeros(L, bar_size, 3);
    fig1 = cat(2, dividing_bar, fig1);
    fig1 = cat(2, fig1, dividing_bar);
    filename2 = sprintf('./results_plots/generated_plots/figure_submaps_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d)_ANATOMY_FTOC.png', epha3, r, g, rep);
    fig2 = cat(2, fig2, imread(filename2));
    fig1 = cat(2, fig1, fig2);
    fig1 = cat(2, fig1, dividing_bar);

    filename3 = sprintf('./results_plots/generated_plots/figure_wholemaps_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d)_ANATOMY_CTOF.png', epha3, r, g, rep);
    fig3 = cat(2, fig3, imread(filename3));
    L = size(fig3, 1);
    dividing_bar = zeros(L, bar_size, 3);
    fig3 = cat(2, dividing_bar, fig3);
    fig3 = cat(2, fig3, dividing_bar);
    filename4 = sprintf('./results_plots/generated_plots/figure_submaps_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d)_ANATOMY_CTOF.png', epha3, r, g, rep);
    fig4 = cat(2, fig4, imread(filename4));
    fig3 = cat(2, fig3, fig4);
    fig3 = cat(2, fig3, dividing_bar);




    %%%%%%
    L = size(fig1, 2);
    dividing_bar = zeros(bar_size, L, 3);
    fig1 = cat(1, dividing_bar, fig1);
    fig1 = cat(1, fig1, dividing_bar);
    fig3 = cat(1, fig3, dividing_bar);
    fig3 = cat(1, dividing_bar, fig3);


    fig = cat(1, fig, fig3);
    fig = cat(1, fig, fig1);

    fig = imresize(fig, 0.5);
    imwrite(fig, "./results_plots/stitched_plots/paper_anatomy_comparison_lattice_plots.png")
%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Statistical Plots
%%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    fig = [];
    fig1 = [];
    fig2 = [];
    fig3 = [];

    bar_size = 5;
    filename1 = sprintf('./results_plots/generated_plots/stats_largest_vfo.png');
    fig1 = cat(2, fig1, imread(filename1));
    L = size(fig1, 1);
    dividing_bar = zeros(L, bar_size, 3);
    %fig1 = cat(2, fig1, dividing_bar);

    filename2 = sprintf('./results_plots/generated_plots/stats_largest_co.png');
    fig2 = cat(2, fig2, imread(filename2));
    L = size(fig2, 1);
    dividing_bar = zeros(L, bar_size, 3);
    %fig2 = cat(2, fig2, dividing_bar);

    filename3 = sprintf('./results_plots/generated_plots/stats_qualities.png');
    fig3 = cat(2, fig3, imread(filename3));
    L = size(fig3, 1);
    dividing_bar = zeros(L, bar_size, 3);
    %fig3 = cat(2, fig3, dividing_bar);

    L = size(fig1, 2);
    dividing_bar = zeros(bar_size, L, 3);
    %fig1 = cat(1, fig1, dividing_bar);

    L = size(fig2, 2);
    dividing_bar = zeros(bar_size, L, 3);
    %fig2 = cat(1, fig2, dividing_bar);

    L = size(fig3, 2);
    dividing_bar = zeros(bar_size, L, 3);
    %fig3 = cat(1, fig3, dividing_bar);


    fig = cat(2, fig, fig1);
    % fig = cat(2, fig, fig2);
    fig = cat(1, fig, fig3);

    fig = imresize(fig, 0.5);
    imwrite(fig, "./results_plots/stitched_plots/paper_statistics_plots.png")
