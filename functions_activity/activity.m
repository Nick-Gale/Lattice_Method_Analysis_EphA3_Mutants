function [bulk_activity_average, phases_average] = activity(collicular_spikes_forward, collicular_spikes_backward, retinal_collicular_connectivity, collicular_positions, dt, time, bar_freq, average_radius, orientation)
    %Calculate the activity rate (number of spikes) in each one second interval
    %and normalise by the average activity in the whole train at each location
    %return activity rates and Fourier phases for both (bar frequency in rads)
    intervals = floor(time / dt);
    
    bulk_activity = mean(collicular_spikes_forward + collicular_spikes_backward, 2) ./ transpose(sum(retinal_collicular_connectivity, 1));
    bulk_activity_average = zeros(size(bulk_activity));
    for i = 1:length(bulk_activity)
        inds_within_radius = find(sqrt((collicular_positions(i, 1) - collicular_positions(:, 1)).^2 + (collicular_positions(i, 2) - collicular_positions(:, 2)).^2) < average_radius);
        bulk_activity_average(i) = sum(bulk_activity(inds_within_radius))/length(inds_within_radius);
    end
    %phases
    fourier_transform_forward = fft(collicular_spikes_forward, [], 2);
    fourier_transform_backward = fft(collicular_spikes_backward, [], 2);
      
    f = 1/dt * (0:size(fourier_transform_forward, 2)/2)/size(fourier_transform_forward, 2);
    target_freq = bar_freq;
    [~, frequency_index] = min( abs( f-target_freq ));
    
    phases_forward = angle(fourier_transform_forward);
    phases_backward = angle(fourier_transform_backward);
    
    phases = mod((phases_backward(:, frequency_index) - phases_forward(:, frequency_index)) / 2, 2 * pi);

    phases_average = zeros(size(phases));
    
    for i = 1:length(phases)
        inds_within_radius = find(sqrt((collicular_positions(i, 1) - collicular_positions(:, 1)).^2 + (collicular_positions(i, 2) - collicular_positions(:, 2)).^2) < average_radius);
        phases_average(i) = sum(phases(inds_within_radius))/length(inds_within_radius);
    end

    inset = 0.01;
    offset = 0.0;
    if orientation == "azimuthal" 
        inds = find(collicular_positions(:, 1) < 1 - inset);
        mean_high_phase = min(phases_average(inds));
        phases_average = mod((mean_high_phase - phases_average + offset), 2 * pi);
    elseif orientation == "elevational"
        inds = find(collicular_positions(:, 2) < inset);
        mean_high_phase = min(phases_average(inds));
        phases_average = mod(-(mean_high_phase - phases_average - offset), 2 * pi);
    end

    inds = convhull(collicular_positions);
    min_phase = min(phases_average(inds));
    max_phase = max(phases_average(inds));
    phase_delta = max_phase - min_phase;
    phases_average = mod(1/phase_delta * (phases_average - min_phase) * 2 * pi, 2 * pi);