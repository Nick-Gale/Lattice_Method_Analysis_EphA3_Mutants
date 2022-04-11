function [] = experiment_plot(SuperLatticeObject, dict)
%function that takes a super lattice object and calls out to Davids plotting programs
id = SuperLatticeObject.id;
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%Activity and Phase Plots
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if SuperLatticeObject.Lattice.input_type == 'SCANNER'
    collicular_positions(:,1) = SuperLatticeObject.Biology.collicular_positions_RC;
    collicular_positions(:,2) = SuperLatticeObject.Biology.collicular_positions_ML;


    %Elevational
    filename = [dict.Phase.directory, 'figure_data_ID(EphA3Ki, Ratio, B2, Repeats): (', sprintf('%0.2f, %0.2f, %d, %d', id(1), id(2),id(3), id(4)), ')_elevational'];
    plot_title = ['Elevational Scan'];

    bulk_activity = SuperLatticeObject.Biology.bulk_activity_elevational;
    phases = SuperLatticeObject.Biology.phases_elevational;

    activity_phase_plot(collicular_positions, bulk_activity, phases, plot_title, filename);

    %Azimuthal
    filename = [dict.Phase.directory, 'figure_data_ID(EphA3Ki, Ratio, B2, Repeats): (', sprintf('%0.2f, %0.2f, %d, %d', id(1), id(2),id(3), id(4)), ')_azimuthal'];
    plot_title = ['Azimuthal Scan'];

    bulk_activity = SuperLatticeObject.Biology.bulk_activity_azimuthal;
    phases = SuperLatticeObject.Biology.phases_azimuthal;

    activity_phase_plot(collicular_positions, bulk_activity, phases, plot_title, filename);
end
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%%Map and Submap Plots 
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% C to F
plot_submaps(SuperLatticeObject, dict.CTOFdictionary, dict.CTOFdictionary.directory_CTOF, 'CTOF', 1)

% F to C
plot_submaps(SuperLatticeObject, dict.FTOCdictionary, dict.FTOCdictionary.directory_FTOC, 'FTOC', 1)
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%% Coverages
%%---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% coverages(SuperLatticeObject.Lattice.CTOFwholemap, SuperLatticeObject.Lattice.CTOFsubmap1, SuperLatticeObject.Lattice.CTOFsubmap2, SuperLatticeObject.Lattice.FTOCwholemap, SuperLatticeObject.Lattice.FTOCsubmap1, SuperLatticeObject.Lattice.FTOCsubmap2, field_x_label, field_y_label, coll_x_label, coll_y_label)