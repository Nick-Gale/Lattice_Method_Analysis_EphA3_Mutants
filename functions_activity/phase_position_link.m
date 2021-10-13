function [vargout] = phase_position_link(scan_type, retinal_firing_rate, baseline_collicular_firing_rate, collicular_inhibitory_scale, collicular_excitatory_scale, collicular_inhibtory_amplitude, collicular_excitatory_amplitude, dt, bar_width, bar_freq, time, average_radius, idxs, retinal_positions_NT, retinal_positions_DV, collicular_positions_RC, collicular_positions_ML, connections, weights, anatomical_scan_radius, seed)
    
%this function takes a scanning type and a connectivity data to generate phases which are asscociated with a colliculus postion.
if scan_type == "ANATOMY"
    [CTOF_full_field_positions, CTOF_full_collicular_positions, FTOC_full_field_positions, FTOC_full_collicular_positions] = anatomical_map(idxs, connections, collicular_positions_RC, collicular_positions_ML, retinal_positions_NT, retinal_positions_DV);
    vargout = {CTOF_full_field_positions, CTOF_full_collicular_positions, FTOC_full_field_positions, FTOC_full_collicular_positions};
end

if scan_type == "SCANNER"
    [phases_azimuthal, phases_elevational, bulk_activity_azimuthal, bulk_activity_elevational] = generate_bulk_phase(retinal_firing_rate, baseline_collicular_firing_rate, collicular_inhibitory_scale, collicular_excitatory_scale, collicular_inhibtory_amplitude, collicular_excitatory_amplitude, dt, bar_width, bar_freq, time, average_radius, idxs, retinal_positions_NT, retinal_positions_DV, collicular_positions_RC, collicular_positions_ML, connections, weights, seed);
    %convenience wrapper variables and phase normalisation
    inds = find(~isnan(bulk_activity_azimuthal));
    inds = find(bulk_activity_azimuthal > 0);
    
    CTOF_full_field_positions(:,1) = phases_azimuthal(inds) / (2 * pi);
    CTOF_full_field_positions(:,2) = phases_elevational(inds) / (2 * pi);

    CTOF_full_collicular_positions(:,1) = collicular_positions_RC(inds);
    CTOF_full_collicular_positions(:,2) = collicular_positions_ML(inds);

    FTOC_full_field_positions = CTOF_full_field_positions;
    FTOC_full_collicular_positions = CTOF_full_collicular_positions;
    vargout = {CTOF_full_field_positions, CTOF_full_collicular_positions, FTOC_full_field_positions, FTOC_full_collicular_positions, phases_azimuthal, phases_elevational, bulk_activity_azimuthal, bulk_activity_elevational};
end
