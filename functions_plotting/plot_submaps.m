function [] = plot_submaps(SuperObject, dictionary, dir, direction, PRINT)

if direction == 'CTOF'
    A = SuperObject.Lattice.CTOFwholemap;
    B = SuperObject.Lattice.CTOFsubmap1;
    C = SuperObject.Lattice.CTOFsubmap2;
elseif direction == 'FTOC'
    A = SuperObject.Lattice.FTOCwholemap;
    B = SuperObject.Lattice.FTOCsubmap1;
    C = SuperObject.Lattice.FTOCsubmap2;
else
    disp('Please use a correct direction FTOC/CTOF')
end

id = SuperObject.id;
divider = SuperObject.Lattice.divider;
input_type = SuperObject.Lattice.input_type;
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Whole-Map Plots
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
figure(1);
clf

text = A.description;

h2 = subplot(2,2,1); %why is this 2? It's the first plot
h1 = subplot(2,2,3);

Dplot_lattice(SuperObject.Lattice, A, dictionary, direction, h1, h2, 'PointNumbers', 0, 'AxisStyle', 'crosshairs_nobars', 'HighStd', 1, 'Orientation', 1, 'Outline', 'both');

hold on
if ~isempty(divider)
    %line([0 1], [divider(2) divider(1) + divider(2)]); 
end

N1 = A.numpoints;
N2 = length(A.points_in_subgraph);

fig = gcf;

subplot(h2)

title(h2, {['ID', sprintf('(%0.2f, %0.2f, %0.2f, %0.2f)', id)]; [text,', Whole map']});

%title(dictionary.whole_map_title1);
subplot(h1)

%title(dictionary.whole_map_title2);
title(['#nodes: ', num2str(N1)]);

h2=subplot(2,2,2);
h1=subplot(2,2,4);

Dplot_lattice(SuperObject.Lattice, A, dictionary, direction, h1, h2, 'SubGraph', 1, 'PointNumbers', 0, 'AxisStyle', 'crosshairs_nobars', 'HighStd', 1, 'Orientation', 1, 'Outline', 'both');

subplot(h2);
title({['(EphA3-Ki, Ilset2-Fraction, Beta2-KO): (', sprintf('%0.2f, %0.2f, %0.2f, %0.2f', id), ')', newline,  direction, ',', input_type]; ['Largest ordered submap']});
%title(dictionary.submap_title1);
subplot(h1)
title(['#nodes: ', num2str(N2), ' of ', num2str(N1), ' (',num2str(round(100 * N2 / N1)),'%)']);
%title(dictionary.submap_title2);
orient tall

if PRINT==1
    
    filename=[dir, 'figure_wholemaps_ID(EphA3Ki, Ratio, B2, Repeats): (', sprintf('%0.2f, %0.2f, %d, %d', id(1), id(2),id(3), id(4)), ')_', input_type, '_', direction, '.png'];
    
    print(filename,'-dpng');
end

%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Part-Map Plots
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if ~isempty(divider)
    figure(2);
    clf

    h2=subplot(2,2,1);
    h1=subplot(2,2,3);

    Dplot_lattice(SuperObject.Lattice, B, dictionary, direction, h1, h2, 'SubGraph', 1, 'PointNumbers', 0, 'AxisStyle', 'crosshairs_nobars', 'HighStd', 1, 'Orientation', 1, 'Outline', 'both');

    hold on

    % if filtering using a regression line
    % line([0 1], [divider(2) divider(1) + divider(2)]);

    % if filtering using mean RC values
    line([divider  divider], [0 1]);

    N11=B.numpoints;
    N12=length(B.points_in_subgraph);
    text1='Partmap 1';

    fig=gcf;
    subplot(h2)

    title({['ID (EphA3-Ki, Ilset2 Fraction, Beta2): (', sprintf('%0.2f, %0.2f, %0.2f, %0.2f', id), '),', newline,  direction, ',', input_type]; [text,', ',text1]});
    %title(dictionary.divider_title1);
    subplot(h1)

    title(['#nodes: ', num2str(N12), ' of ', num2str(N11), ' (',num2str(round(100*N12/N11)),'%)']);
    %title(dictionary.divider_title1);
    h2=subplot(2,2,2);
    h1=subplot(2,2,4);

    Dplot_lattice(SuperObject.Lattice, C, dictionary, direction, h1, h2, 'SubGraph', 1, 'PointNumbers', 0, 'AxisStyle', 'crosshairs_nobars', 'HighStd', 1, 'Orientation', 1, 'Outline', 'both');

    hold on
    % if filtering using a regression line
    % line([0 1], [divider(2) divider(1) + divider(2)]);

    % if filtering using mean RC values
    line([divider  divider], [0 1]);
    
    N21=C.numpoints;
    N22=length(C.points_in_subgraph);
    text1='Partmap 2';

    subplot(h2)
    plot(1:100/100, 1:100/100)

    title({[text1, ', %extra nodes'];['in separate maps: ', num2str(round(100*(N12+N22-N2)/N2))]});
    %title(dictionary.divider_title3);
    subplot(h1)

    title(['#nodes: ', num2str(N22), ' of ',num2str(N21), ' (',num2str(round(100*N22/N21)),'%)']);
    %title(dictionary.divider_title4);
    orient tall

    if PRINT==1
        filename=[dir, 'figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (', sprintf('%0.2f, %0.2f, %d, %d', id(1), id(2),id(3), id(4)), ')_', input_type, '_', direction, '.png'];
        print(filename,'-dpng');
    end
end

