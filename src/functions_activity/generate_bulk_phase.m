function [phases_azimuthal, phases_elevational, bulk_activity_azimuthal, bulk_activity_elevational] = generate_bulk_phase(retinal_firing_rate, baseline_collicular_firing_rate, collicular_inhibitory_scale, collicular_excitatory_scale, collicular_inhibtory_amplitude, collicular_excitatory_amplitude, dt, bar_width, bar_freq, time, average_radius, idxs, rx, ry, cx, cy, connections, weights, seed)
%% Load data and generate collicular connectivity
L_c = length(cx);
L_r = length(rx);

retinal_collicular_connectivity = zeros(L_c, L_r);
retinal_positions = zeros(L_r, 2);
collicular_positions = zeros(L_c, 2);
    
collicular_positions(:, 1) = cx;
collicular_positions(:, 2) = cy;
retinal_positions(:, 1) = rx;
retinal_positions(:, 2) = ry;

retinal_collicular_connectivity = zeros(L_c, L_r);
for i = 1:L_c
    indexes = intersect(connections(:, i), idxs);
    non_zero = indexes(indexes ~= 0);

    %colliculus indexes are in the rows, retinal connections are in the columns
    %retinal_collicular_connectivity(i, non_zero) = weights(indexes ~= 0);
    for j = 1:length(indexes)
        if indexes(j) > 0
            retinal_collicular_connectivity(i, indexes(j)) = retinal_collicular_connectivity(i, indexes(j)) + 1;
        end
    end
end

%D_mat_square = (meshgrid((collicular_positions(:, 1))) - transpose(meshgrid(collicular_positions(:, 1)))) .^2 + (meshgrid((collicular_positions(:, 2))) - transpose(meshgrid(collicular_positions(:, 2)))) .^2;
%collicular_collicular_connectivity = collicular_excitatory_amplitude * exp(-D_mat_square / (2 * collicular_excitatory_scale)) - collicular_inhibtory_amplitude * exp(-D_mat_square / (2 * collicular_inhibitory_scale));
collicular_collicular_connectivity = zeros(L_c, L_c);
for i = 1:L_c
    for j = 1:L_c
        d2 = (collicular_positions(i, 1) - collicular_positions(j, 1))^2 + (collicular_positions(i, 2) - collicular_positions(j, 2))^2;
        collicular_collicular_connectivity(i,j) = collicular_excitatory_amplitude * exp(-d2 / (2 * collicular_excitatory_scale^2)) - collicular_inhibtory_amplitude * exp(-d2 / (2 * collicular_inhibitory_scale^2));
    end
end
%% Generate spiking activity
disp("Generating spiking activity")
%retinal
[retinal_spike_trains_forward_azimuthal, retinal_spike_trains_backward_azimuthal] = retinal_spikes(retinal_positions, time, dt, retinal_firing_rate, bar_width, bar_freq, 'azimuthal', seed, idxs);
[retinal_spike_trains_forward_elevational, retinal_spike_trains_backward_elevational] = retinal_spikes(retinal_positions, time, dt, retinal_firing_rate, bar_width, bar_freq, 'elevational', seed, idxs);

%collicular
[collicular_spike_trains_forward_azimuthal, collicular_spike_trains_backward_azimuthal] = collicular_spikes(collicular_positions, retinal_spike_trains_forward_azimuthal, retinal_spike_trains_backward_azimuthal, retinal_collicular_connectivity, collicular_collicular_connectivity, baseline_collicular_firing_rate, time, dt, seed);
[collicular_spike_trains_forward_elevational, collicular_spike_trains_backward_elevational] = collicular_spikes(collicular_positions, retinal_spike_trains_forward_elevational, retinal_spike_trains_backward_elevational, retinal_collicular_connectivity, collicular_collicular_connectivity, baseline_collicular_firing_rate, time, dt, seed);

%% Calculate bulk activity and phases
disp("Generating bulk activity and phase information")
[bulk_activity_azimuthal, phases_azimuthal] = activity(collicular_spike_trains_forward_azimuthal, collicular_spike_trains_backward_azimuthal, retinal_collicular_connectivity, collicular_positions, dt, time, bar_freq, average_radius, 'azimuthal');
[bulk_activity_elevational, phases_elevational] = activity(collicular_spike_trains_forward_elevational, collicular_spike_trains_backward_elevational, retinal_collicular_connectivity, collicular_positions, dt, time, bar_freq, average_radius, 'elevational');

clearvars D_mat_square collicular_collicular_connectivitiy retinal_spike_trains_forward_azimuthal retinal_spike_trains_backward_azimuthal retinal_spike_trains_forward_elevational retinal_spike_trains_backward_elevational retinal_spike_trains_backward_elevational collicular_spike_trains_forward_azimuthal collicular_spike_trains_backward_azimuthal collicular_spike_trains_forward_elevational collicular_spike_trains_backward_elevational
end

