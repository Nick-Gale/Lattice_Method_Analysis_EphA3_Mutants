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

    h2 = subplot(2,2,1);
    h1 = subplot(2,2,3);

    Dplot_lattice(SuperObject.Lattice, A, dictionary, direction, h1, h2, 'PointNumbers', 0, 'AxisStyle', 'crosshairs_nobars', 'HighStd', 1, 'Orientation', 1, 'Outline', 'both');
    hold on

    N1 = A.numpoints;
    N2 = length(A.points_in_subgraph);

    fig = gcf;

    subplot(h2);
    if isfield(dictionary, 'whole_map_title1')
        % title([direction ' ' SuperObject.Lattice.input_type ': ' dictionary.whole_map_title1]);
    else
        title('');
    end
    % title(h2, {['ID', sprintf('(%0.2f, %0.2f, %0.2f, %0.2f)', id)]; [text,', Whole map']});
    if isfield(dictionary, 'part_subplot1_xlabel')
        xlabel(dictionary.part_subplot1_xlabel);
    else
        xlabel('')
    end

    if isfield(dictionary, 'part_subplot1_ylabel')
        ylabel(dictionary.part_subplot1_ylabel);
    else
        ylabel('');
    end

    subplot(h1)
    % title(['n(nodes): ', num2str(N1)]);
    if isfield(dictionary, 'part_subplot3_xlabel')
        xlabel(dictionary.part_subplot3_xlabel);
    else
        xlabel('');
    end
    h2=subplot(2,2,2);
    h1=subplot(2,2,4);

    Dplot_lattice(SuperObject.Lattice, A, dictionary, direction, h1, h2, 'SubGraph', 1, 'PointNumbers', 0, 'AxisStyle', 'crosshairs_nobars', 'HighStd', 1, 'Orientation', 1, 'Outline', 'both');

    subplot(h2);
    if isfield(dictionary, 'whole_map_title2')
        % title([direction ' ' SuperObject.Lattice.input_type ': ' dictionary.whole_map_title2]);
    else
        title('')
    end
    % title({['(EphA3-Ki, Ilset2-Fraction, Beta2-KO): (', sprintf('%0.2f, %0.2f, %0.2f, %0.2f', id), ')', newline,  direction, ',', input_type]; ['Largest ordered submap']});
    if isfield(dictionary, 'part_subplot2_xlabel')
        xlabel(dictionary.part_subplot2_xlabel);
    else
        xlabel('');
    end

    if isfield(dictionary, 'part_subplot2_ylabel')
        ylabel(dictionary.part_subplot2_ylabel);
    else
        ylabel('');
    end


    subplot(h1)
    % title(['n(nodes): ', num2str(N2), ' of ', num2str(N1), ' (',num2str(round(100 * N2 / N1)),'%)']);

    if isfield(dictionary, 'part_subplot4_xlabel')
        xlabel(dictionary.part_subplot4_xlabel);
    else
        xlabel('');
    end
    
    if isfield(dictionary, 'part_subplot4_ylabel')
        ylabel(dictionary.part_subplot4_ylabel);
    else
        ylabel('');
    end
    orient tall

    if PRINT==1
        filename=[dir, 'figure_wholemaps_ID(EphA3Ki, Ratio, B2, Repeats): (', sprintf('%0.2f, %0.2f, %d, %d', id(1), id(2),id(3), id(4)), ')_', input_type, '_', direction, '.png'];
        print(filename, '-dpng')
    end

%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Part-Map Plots
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if ~isempty(divider)
    figure(2);
    clf

    h2=subplot(2,2,1);
    h1=subplot(2,2,3);

    Dplot_lattice(SuperObject.Lattice, B, dictionary, direction, h1, h2, 'SubGraph', 1, 'PointNumbers', 0, 'AxisStyle', 'crosshairs_nobars', 'HighStd', 1, 'Orientation', 1, 'Outline', 'both')
    hold on;

    % if filtering using mean RC values
    line([divider  divider], [0 1]);

    N11=B.numpoints;
    N12=length(B.points_in_subgraph);

    fig=gcf;
    subplot(h2);

    if isfield(dictionary, 'part_title1')
        % title([direction ' ' SuperObject.Lattice.input_type ': ' dictionary.part_title1]);
    else
        title('');
    end

    subtitle('');

    if isfield(dictionary, 'part_subplot1_xlabel')
        xlabel(dictionary.part_subplot1_xlabel);
    else
        xlabel('')
    end

    if isfield(dictionary, 'part_subplot1_ylabel')
        ylabel(dictionary.part_subplot1_ylabel);
    else
        ylabel('');
    end

    subplot(h1)

    %title2 = sprintf('n(nodes): %d of %d (%d%%)', N12, N11, round(100*N12/N11));
    %title(title2)

    if isfield(dictionary, 'part_subplot3_xlabel')
        xlabel(dictionary.part_subplot3_xlabel);
    else
        xlabel('');
    end

    ylabel(dictionary.part_subplot3_ylabel)
    h2=subplot(2,2,2);

    h1=subplot(2,2,4);

    Dplot_lattice(SuperObject.Lattice, C, dictionary, direction, h1, h2, 'SubGraph', 1, 'PointNumbers', 0, 'AxisStyle', 'crosshairs_nobars', 'HighStd', 1, 'Orientation', 1, 'Outline', 'both');

    hold on

    % if filtering using mean RC values
    line([divider  divider], [0 1]);
    
    N21=C.numpoints;
    N22=length(C.points_in_subgraph);
    text1='Part-map 2';

    subplot(h2)
    plot(1:100/100, 1:100/100)
    if isfield(dictionary, 'part_title3')
        %title([direction ' ' SuperObject.Lattice.input_type ': ' dictionary.part_title3]);
    else
        title('');
    end
    subtitle('');
    
    if isfield(dictionary, 'part_subplot2_xlabel')
        xlabel(dictionary.part_subplot2_xlabel);
    else
        xlabel('');
    end

    if isfield(dictionary, 'part_subplot2_ylabel')
        ylabel(dictionary.part_subplot2_ylabel);
    else
        ylabel('');
    end

    subplot(h1)

    %title4 = sprintf('n(nodes): %d of %d (%d%%)', N22, N21, round(100*N22/N21));
    %title(title4);

    if isfield(dictionary, 'part_subplot4_xlabel')
        xlabel(dictionary.part_subplot4_xlabel);
    else
        xlabel('');
    end
    
    if isfield(dictionary, 'part_subplot4_ylabel')
        ylabel(dictionary.part_subplot4_ylabel);
    else
        ylabel('');
    end


    % put the overlaps
    shrink = 0.2; % PUT THIS IN THE DICTIONARY
    if direction == "FTOC"
        poly1 = polyshape(B.coll_chosen(boundary(B.coll_chosen(:, 1), B.coll_chosen(:, 2), shrink), :));
        poly2 = polyshape(C.coll_chosen(boundary(C.coll_chosen(:, 1), C.coll_chosen(:, 2), shrink), :));
        poly_intersect = intersect(poly2, poly1);
        subplot(2,2,3)
        plot(poly_intersect, 'FaceColor', [0.4940 0.1840 0.5560])
        alpha(0.1)
        subplot(2,2,4)
        plot(poly_intersect, 'FaceColor', [0.4940 0.1840 0.5560])
        alpha(0.1)
    end

    if direction == "CTOF"
        poly1 = polyshape(B.field_chosen(boundary(B.field_chosen(:, 1), B.field_chosen(:, 2), shrink), :));
        poly2 = polyshape(C.field_chosen(boundary(C.field_chosen(:, 1), C.field_chosen(:, 2), shrink), :));
        poly_intersect = intersect(poly2, poly1);
        subplot(2,2,1)
        plot(poly_intersect, 'FaceColor', [0.4940 0.1840 0.5560])
        alpha(0.1)
        subplot(2,2,2)
        plot(poly_intersect, 'FaceColor', [0.4940 0.1840 0.5560])
        alpha(0.1)
    end



    orient tall

    if PRINT==1
        filename=[dir, 'figure_submaps_ID(EphA3Ki, Ratio, B2, Repeats): (', sprintf('%0.2f, %0.2f, %d, %d', id(1), id(2),id(3), id(4)), ')_', input_type, '_', direction, '.png'];
        % exportgraphics(gcf, filename, 'Resolution', 500)
        print(filename, '-dpng')
    end
end

