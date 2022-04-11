function MapObject = experiment_analysis(hjorth_object, scan_type, dict, id, data_source)
%% In this function we are analysing a retinal object and generating a lattice object and results. The output object contains several fields broken into three major components: Biological, Lattice, and Results.
%% The biological subfield contains relevant measurements from either data or a model output - the lattice object inputs. In this case it's a Hjorth Retinal Object.
%% The results subfield contains the data that will be used to generate statistics and plots
%% The lattice subfield contains all the data required for a lattice object
rng(dict.random_seed, 'twister')
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if data_source == 'SIMULATION'
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Pull the relevant biological data.
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
    collicular_positions_RC = hjorth_object.SCap;
    collicular_positions_ML = hjorth_object.SCml;
    retinal_positions_NT = hjorth_object.RGCnt;
    retinal_positions_DV = hjorth_object.RGCdv;

    full_indexes = 1:length(collicular_positions_RC(:,1));
    ephA3 = hjorth_object.Isl2PositiveRGC;
    WT = setdiff(full_indexes, ephA3);

    connections = hjorth_object.presynapticConnections;
    weights = hjorth_object.presynapticWeight;

    SCephrinA = hjorth_object.SCephrinA;
    SCephrinB = hjorth_object.SCephrinB;

    RGCEphA = hjorth_object.RGCEphA;
    RGCEphB = hjorth_object.RGCEphB;
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Perform the scanning and create phase-position linkages
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
    %read out is optionally lengthed with phases for scanning type (CtoF, CtoF, FtoC, FtoC; phase1, phase2, activity1, activity2)
    phase_activity_readout = phase_position_link(scan_type, dict.retinal_firing_rate, dict.baseline_collicular_firing_rate, dict.collicular_inhibitory_scale, dict.collicular_excitatory_scale, dict.collicular_inhibtory_amplitude, dict.collicular_excitatory_amplitude, dict.dt, dict.bar_width, dict.bar_freq, dict.time, dict.average_radius, 1:length(retinal_positions_NT), retinal_positions_NT, retinal_positions_DV, collicular_positions_RC, collicular_positions_ML, connections, weights, dict.random_seed);
    CTOF_full_field_positions = phase_activity_readout{1}; CTOF_full_collicular_positions = phase_activity_readout{2};
    FTOC_full_field_positions = phase_activity_readout{3}; FTOC_full_collicular_positions = phase_activity_readout{4};
    if scan_type == 'SCANNER'
        phases_azimuthal = phase_activity_readout{5}; phases_elevational = phase_activity_readout{6};
        bulk_activity_azimuthal = phase_activity_readout{7}; bulk_activity_elevational = phase_activity_readout{8};
    end
end
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if data_source == 'EXPERIMENT'
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Pull the relevant simulated data.
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    measured_data_readout = experimental_data_progam();
    CTOF_full_field_positions = []; CTOF_full_collicular_positions = [];
    FTOC_full_field_positions = []; FTOC_full_collicular_positions = [];
    phases_azimuthal = []; phases_elevational = [];
    bulk_activity_azimuthal = [];  bulk_activity_elevational = [];
end
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Filter the scanning data
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%
    disp("Filtering only on CTOF Projection")
    [CTOF_full_field_filtered, CTOF_full_collicular_filtered, CTOF_retained_indexes, CTOF_filtered_indexes] = filter_highdeviation(CTOF_full_field_positions, CTOF_full_collicular_positions, dict.filter_threshold, dict.filter_collicular_radius, "CTOF");
    FTOC_full_field_filtered = FTOC_full_field_positions; FTOC_full_collicular_filtered = FTOC_full_collicular_positions; FTOC_retained_indexes = 1:size(FTOC_full_field_positions, 1); FTOC_filtered_indexes = [];
    ratio_of_filtered = length(CTOF_retained_indexes) / length(CTOF_full_field_positions);

    %create dividing lines
    if ~isempty(CTOF_filtered_indexes)
        divider = create_divider(CTOF_full_collicular_positions(CTOF_filtered_indexes, 1), CTOF_full_collicular_positions(CTOF_filtered_indexes, 2));
    else
        divider = 0.5;
    end

    %make all points unique; these are the points that go into the lattice program
    [CTOF_full_field_unique, CTOF_full_collicular_unique, FTOC_full_field_unique, FTOC_full_collicular_unique] = uniquify_point_positions(CTOF_full_field_filtered, CTOF_full_collicular_filtered, FTOC_full_field_filtered, FTOC_full_collicular_filtered, dict.unique_noise_parameter);


    %label the indexes used in each of the part maps acording to a dividing line, or retinal origin
    CTOF_wholemap_indexes = 1:length(CTOF_full_collicular_unique(:, 1)); 
    CTOF_submap1_indexes = filter_divider(CTOF_full_collicular_unique, divider, "right"); 
    CTOF_submap2_indexes = filter_divider(CTOF_full_collicular_unique, divider, "left");

    FTOC_wholemap_indexes = 1:length(FTOC_full_field_unique(:, 1)); 
    FTOC_ephA3_indexes = intersect(ephA3, FTOC_retained_indexes);
    FTOC_submap1_indexes = arrayfun(@(x) find(FTOC_retained_indexes==x, 1), FTOC_ephA3_indexes);
    FTOC_WT_indexes = intersect(WT, FTOC_retained_indexes);
    FTOC_submap2_indexes = arrayfun(@(x) find(FTOC_retained_indexes==x, 1), FTOC_WT_indexes);

%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Perform the lattice method on the six subsets of retinocollicur cells: this is a series of 5 top level calls and a bunch of bottom level calls found in ./functions_lattice_method. Details found in Willshaw Paper.
%% Results of the computation are stored in the lattice object indexed by: CTOFwholemap, CTOFsubmap1, CTOFsubmap2, FTOCwholemap, FTOCsubmap1, FTOCsubmap2
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
    %% Whole-Maps

    CTOFwholemap = lattice("CTOF", CTOF_wholemap_indexes, CTOF_full_field_unique, CTOF_full_collicular_unique, dict.CTOF_area_scaling, dict.spacing_points_fraction, dict.spacing_radius_multiplier, dict.spacing_upper_bound, dict.spacing_lower_bound, dict.min_points, dict.triangle_tolerance, dict.max_trial_scale_factor, dict.min_spacing_fraction, dict.min_spacing_reduction_factor, dict.random_seed, 1);
    disp("CTOF: Whole - done")
    FTOCwholemap = lattice("FTOC", FTOC_wholemap_indexes, FTOC_full_field_unique, FTOC_full_collicular_unique, dict.FTOC_area_scaling, dict.spacing_points_fraction, dict.spacing_radius_multiplier, dict.spacing_upper_bound, dict.spacing_lower_bound, dict.min_points, dict.triangle_tolerance, dict.max_trial_scale_factor, dict.min_spacing_fraction, dict.min_spacing_reduction_factor, dict.random_seed, 1);
    disp("FTOC: Whole - done")

    %% Part-Maps

    chosen_indexes = CTOFwholemap.chosen_indexes;
    CTOF_submap1_indexes = chosen_indexes(filter_divider(CTOFwholemap.coll_chosen, divider, "right"));
    CTOF_submap2_indexes = chosen_indexes(filter_divider(CTOFwholemap.coll_chosen, divider, "left"));

    if ~isempty(CTOF_submap1_indexes)
        CTOFsubmap1 = lattice("CTOF", CTOF_submap1_indexes, CTOF_full_field_unique, CTOF_full_collicular_unique, dict.CTOF_area_scaling, dict.spacing_points_fraction, dict.spacing_radius_multiplier, dict.spacing_upper_bound, dict.spacing_lower_bound, dict.min_points, dict.triangle_tolerance, dict.max_trial_scale_factor, dict.min_spacing_fraction, dict.min_spacing_reduction_factor, dict.random_seed, dict.create_new_map_CTOF);
    else
        CTOFsubmap1 = lattice("CTOF", CTOF_submap2_indexes, CTOF_full_field_unique, CTOF_full_collicular_unique, dict.CTOF_area_scaling, dict.spacing_points_fraction, dict.spacing_radius_multiplier, dict.spacing_upper_bound, dict.spacing_lower_bound, dict.min_points, dict.triangle_tolerance, dict.max_trial_scale_factor, dict.min_spacing_fraction, dict.min_spacing_reduction_factor, dict.random_seed, dict.create_new_map_CTOF);
    end
    disp("CTOF: Submap 1 - done")

    if ~isempty(CTOF_submap2_indexes)
        CTOFsubmap2 = lattice("CTOF", CTOF_submap2_indexes, CTOF_full_field_unique, CTOF_full_collicular_unique, dict.CTOF_area_scaling, dict.spacing_points_fraction, dict.spacing_radius_multiplier, dict.spacing_upper_bound, dict.spacing_lower_bound, dict.min_points, dict.triangle_tolerance, dict.max_trial_scale_factor, dict.min_spacing_fraction, dict.min_spacing_reduction_factor, dict.random_seed, dict.create_new_map_CTOF);
    else
        CTOFsubmap2 = lattice("CTOF", CTOF_submap1_indexes, CTOF_full_field_unique, CTOF_full_collicular_unique, dict.CTOF_area_scaling, dict.spacing_points_fraction, dict.spacing_radius_multiplier, dict.spacing_upper_bound, dict.spacing_lower_bound, dict.min_points, dict.triangle_tolerance, dict.max_trial_scale_factor, dict.min_spacing_fraction, dict.min_spacing_reduction_factor, dict.random_seed, dict.create_new_map_CTOF);
    end
    disp("CTOF: Submap 2 - done")

    if ~isempty(FTOC_submap1_indexes)
        % perform a rescan
        phase_activity_readout = phase_position_link(scan_type, dict.retinal_firing_rate, dict.baseline_collicular_firing_rate, dict.collicular_inhibitory_scale, dict.collicular_excitatory_scale, dict.collicular_inhibtory_amplitude, dict.collicular_excitatory_amplitude, dict.dt, dict.bar_width, dict.bar_freq, dict.time, dict.average_radius, FTOC_submap1_indexes, retinal_positions_NT, retinal_positions_DV, collicular_positions_RC, collicular_positions_ML, connections, weights, dict.random_seed);
        CTOF_full_field_positions_part = phase_activity_readout{1}; CTOF_full_collicular_positions_part = phase_activity_readout{2};
        FTOC_full_field_positions_part = phase_activity_readout{3}; FTOC_full_collicular_positions_part = phase_activity_readout{4};
        FTOCsubmap1 = lattice("FTOC", FTOC_submap1_indexes, FTOC_full_field_positions_part, FTOC_full_collicular_positions_part, dict.FTOC_area_scaling, 1.0 * dict.spacing_points_fraction, dict.spacing_radius_multiplier, dict.spacing_upper_bound, dict.spacing_lower_bound, 0.5 * dict.min_points, dict.triangle_tolerance, dict.max_trial_scale_factor, dict.min_spacing_fraction, dict.min_spacing_reduction_factor, dict.random_seed, dict.create_new_map_FTOC);
    else
        % perform a rescan
        phase_activity_readout = phase_position_link(scan_type, dict.retinal_firing_rate, dict.baseline_collicular_firing_rate, dict.collicular_inhibitory_scale, dict.collicular_excitatory_scale, dict.collicular_inhibtory_amplitude, dict.collicular_excitatory_amplitude, dict.dt, dict.bar_width, dict.bar_freq, dict.time, dict.average_radius, FTOC_submap2_indexes, retinal_positions_NT, retinal_positions_DV, collicular_positions_RC, collicular_positions_ML, connections, weights, dict.random_seed);
        CTOF_full_field_positions_part = phase_activity_readout{1}; CTOF_full_collicular_positions_part = phase_activity_readout{2};
        FTOC_full_field_positions_part = phase_activity_readout{3}; FTOC_full_collicular_positions_part = phase_activity_readout{4};
        FTOCsubmap1 = lattice("FTOC", FTOC_submap2_indexes, FTOC_full_field_positions_part, FTOC_full_collicular_positions_part, dict.FTOC_area_scaling, dict.spacing_points_fraction, dict.spacing_radius_multiplier, dict.spacing_upper_bound, dict.spacing_lower_bound, dict.min_points, dict.triangle_tolerance, dict.max_trial_scale_factor, dict.min_spacing_fraction, dict.min_spacing_reduction_factor, dict.random_seed, dict.create_new_map_FTOC);
    end
    disp("FTOC: Submap 1 - done")

    if ~isempty(FTOC_submap2_indexes)
        % perform a rescan
        phase_activity_readout = phase_position_link(scan_type, dict.retinal_firing_rate, dict.baseline_collicular_firing_rate, dict.collicular_inhibitory_scale, dict.collicular_excitatory_scale, dict.collicular_inhibtory_amplitude, dict.collicular_excitatory_amplitude, dict.dt, dict.bar_width, dict.bar_freq, dict.time, dict.average_radius, FTOC_submap2_indexes, retinal_positions_NT, retinal_positions_DV, collicular_positions_RC, collicular_positions_ML, connections, weights, dict.random_seed);
        CTOF_full_field_positions_part = phase_activity_readout{1}; CTOF_full_collicular_positions_part = phase_activity_readout{2};
        FTOC_full_field_positions_part = phase_activity_readout{3}; FTOC_full_collicular_positions_part = phase_activity_readout{4};
        FTOCsubmap2 = lattice("FTOC", FTOC_submap2_indexes, FTOC_full_field_positions_part, FTOC_full_collicular_positions_part, dict.FTOC_area_scaling, 1.0 * dict.spacing_points_fraction, dict.spacing_radius_multiplier, dict.spacing_upper_bound, dict.spacing_lower_bound, dict.min_points, dict.triangle_tolerance, dict.max_trial_scale_factor, dict.min_spacing_fraction, dict.min_spacing_reduction_factor, dict.random_seed, dict.create_new_map_FTOC);
    else
        % perform a rescan
        phase_activity_readout = phase_position_link(scan_type, dict.retinal_firing_rate, dict.baseline_collicular_firing_rate, dict.collicular_inhibitory_scale, dict.collicular_excitatory_scale, dict.collicular_inhibtory_amplitude, dict.collicular_excitatory_amplitude, dict.dt, dict.bar_width, dict.bar_freq, dict.time, dict.average_radius, FTOC_submap1_indexes, retinal_positions_NT, retinal_positions_DV, collicular_positions_RC, collicular_positions_ML, connections, weights, dict.random_seed);
        CTOF_full_field_positions_part = phase_activity_readout{1}; CTOF_full_collicular_positions_part = phase_activity_readout{2};
        FTOC_full_field_positions_part = phase_activity_readout{3}; FTOC_full_collicular_positions_part = phase_activity_readout{4};
        FTOCsubmap2 = lattice("FTOC", FTOC_submap1_indexes, FTOC_full_field_positions_part, FTOC_full_collicular_positions_part, dict.FTOC_area_scaling, dict.spacing_points_fraction, dict.spacing_radius_multiplier, dict.spacing_upper_bound, dict.spacing_lower_bound, dict.min_points, dict.triangle_tolerance, dict.max_trial_scale_factor, dict.min_spacing_fraction, dict.min_spacing_reduction_factor, dict.random_seed, dict.create_new_map_FTOC);
    end
    disp("FTOC: Submap 2 - done")

%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Construct the map object which contains the biological information, the lattice information, and the statistical information
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    MapObject.Biology.collicular_positions_RC = collicular_positions_RC;
    MapObject.Biology.collicular_positions_ML = collicular_positions_ML;
    MapObject.Biology.retinal_positions_NT = retinal_positions_NT;
    MapObject.Biology.retinal_positions_DV = retinal_positions_DV;
    MapObject.Biology.ephA3 = ephA3;
    MapObject.Biology.connections = connections;
    MapObject.Biology.weights = weights;
    MapObject.Biology.RGCEphA = RGCEphA;
    MapObject.Biology.RGCEphB = RGCEphB;
    MapObject.Biology.SCephrinA = SCephrinA;
    MapObject.Biology.SCephrinB = SCephrinB;
    if scan_type == 'SCANNER';
        MapObject.Biology.phases_azimuthal = phases_azimuthal;
        MapObject.Biology.phases_elevational = phases_elevational;
        MapObject.Biology.bulk_activity_azimuthal = bulk_activity_azimuthal;
        MapObject.Biology.bulk_activity_elevational = bulk_activity_elevational;
    end
    MapObject.id = id;
    MapObject.Lattice.filter_ratio = ratio_of_filtered;
    MapObject.Lattice.divider = divider;
    MapObject.Lattice.input_type = scan_type;
    MapObject.Lattice.CTOFwholemap = CTOFwholemap;
    MapObject.Lattice.CTOFsubmap1 = CTOFsubmap1;
    MapObject.Lattice.CTOFsubmap2 = CTOFsubmap2;
    MapObject.Lattice.FTOCwholemap = FTOCwholemap;
    MapObject.Lattice.CTOF_full_field_positions = CTOF_full_field_positions;
    MapObject.Lattice.filtered_indexes_CTOF = CTOF_filtered_indexes;
    MapObject.Lattice.filtered_field_CTOF = CTOF_full_field_positions(CTOF_filtered_indexes, :);
    MapObject.Lattice.filtered_colliculus_CTOF = CTOF_full_collicular_positions(CTOF_filtered_indexes, :);
    MapObject.Lattice.retained_field_CTOF = CTOF_full_field_positions(CTOF_retained_indexes, :);
    MapObject.Lattice.retained_colliculus_CTOF = CTOF_full_collicular_positions(CTOF_retained_indexes, :);
    MapObject.Lattice.filtered_indexes_FTOC = FTOC_filtered_indexes;
    MapObject.Lattice.filtered_field_FTOC = FTOC_full_field_positions(FTOC_filtered_indexes, :);
    MapObject.Lattice.filtered_colliculus_FTOC = FTOC_full_collicular_positions(FTOC_filtered_indexes, :);    
    MapObject.Lattice.retained_field_FTOC = FTOC_full_field_positions(FTOC_retained_indexes, :);
    MapObject.Lattice.retained_colliculus_FTOC = FTOC_full_collicular_positions(FTOC_retained_indexes, :);
    MapObject.Lattice.FTOCsubmap1 = FTOCsubmap1;
    MapObject.Lattice.FTOCsubmap2 = FTOCsubmap2;
    MapObject.Lattice.statistics = stats(CTOFwholemap, CTOFsubmap1, CTOFsubmap2, FTOCwholemap, FTOCsubmap1, FTOCsubmap2);