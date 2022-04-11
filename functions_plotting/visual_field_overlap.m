function [] = visual_field_overlap(obj, dict)
    % this function takes a super object and produces an image with six subplots: 
    % 1. Colour coded retinal location
    % 2. Colour coded gradients with two lines showing where slices in the DV axis are to be taken. Gradients are Eph in the retina and Eprhin in the colliculus - both the A system
    % 3. The average phase projection of all collicular cells within a threshold of slice ML
    % 4. The average anatomical projection of all collicular cells within a threshold of slice ML
    % 5. The average projection of epha3 and wt cell colour coded within a threshold slice DV
    % 6. The distribution of cells over the collicilus colour coded

%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Load Data
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    collicular_positions_RC = obj.Biology.collicular_positions_RC;
    collicular_positions_ML = obj.Biology.collicular_positions_ML;
    retinal_positions_NT = obj.Biology.retinal_positions_NT;
    retinal_positions_DV = obj.Biology.retinal_positions_DV;
    ephA3_indexes = obj.Biology.ephA3;

    partmap1_field = obj.Lattice.CTOFsubmap1.field_chosen;
    partmap1_coll = obj.Lattice.CTOFsubmap1.coll_chosen;

    partmap2_field = obj.Lattice.CTOFsubmap2.field_chosen;
    partmap2_coll = obj.Lattice.CTOFsubmap2.coll_chosen;
    id = obj.id;
    divider = obj.Lattice.divider;
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Load Parameters
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    cb = [0, 0.4470, 0.7410];
    cr = [0.6350, 0.0780, 0.1840];
    cp = [0.4940, 0.1840, 0.5560];
    sz = 20;
    shrink = 0.2;
    save_dir = strcat(dict.directory, sprintf('figure_visual_field_overlap_ID(EphA3Ki, Ratio, Gamma, Repeat): (%0.2f, %0.2f, %d, %d).png', id(1), id(2), id(3), id(4)));
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Create plotting data
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    geom1 = boundary(partmap1_field(:, 1), partmap1_field(:, 2), shrink);
    geom2 = boundary(partmap2_field(:, 1), partmap2_field(:, 2), shrink);

    p1_indexes_g2 = find(inpolygon(partmap1_field(:, 1), partmap1_field(:, 2), partmap2_field(geom2, 1), partmap2_field(geom2, 2)));
    p2_indexes_g1 = find(inpolygon(partmap2_field(:, 1), partmap2_field(:, 2), partmap1_field(geom1, 1), partmap1_field(geom1, 2)));
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Plot
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    fig = figure(2);    
    subplot(2,1,1)
    hold on
    scatter(partmap1_field(:, 1), partmap1_field(:, 2), sz, cb, 'filled');
    scatter(partmap2_field(:, 1), partmap2_field(:, 2), sz, cr, 'filled');
    if ~isempty(p1_indexes_g2)
        scatter(partmap1_field(p1_indexes_g2, 1), partmap1_field(p1_indexes_g2, 2), sz, cp, 'filled');
    end
    if ~isempty(p1_indexes_g2)
        scatter(partmap2_field(p2_indexes_g1, 1), partmap2_field(p2_indexes_g1, 2), sz, cp, 'filled');
    end
    set(gca, 'XDir','reverse');
    axis equal;
    axis([0 1 0 1]);

    subplot(2,1,2)
    hold on
    scatter(partmap1_coll(:, 1), partmap1_coll(:, 2), sz, cb, 'filled');
    scatter(partmap2_coll(:, 1), partmap2_coll(:, 2), sz, cr, 'filled');

    if ~isempty(p1_indexes_g2)
        scatter(partmap1_coll(p1_indexes_g2, 1), partmap1_coll(p1_indexes_g2, 2), sz, cp, 'filled');
    end
    if ~isempty(p2_indexes_g1)
        scatter(partmap2_coll(p2_indexes_g1, 1), partmap2_coll(p2_indexes_g1, 2), sz, cp, 'filled');
    end
    line([divider  divider], [0 1], 'Color', 'black');
    axis equal;
    axis([0 1 0 1]);
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Save
%--------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%print(save_dir,'-dpng');
exportgraphics(fig, save_dir, 'Resolution', 500);
close(fig)


