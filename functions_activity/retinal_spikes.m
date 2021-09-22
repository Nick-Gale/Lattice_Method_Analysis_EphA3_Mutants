function [spike_trains_forward, spike_trains_backward] = retinal_spikes(retinal_positions, time, dt, firing_rate, bar_width, bar_freq, orientation, seed)
%bar frequency in rads
rng(seed, 'twister')
n_neurones = length(retinal_positions);
intervals = floor(1/dt * time);
spike_trains_forward = zeros(n_neurones, intervals);
spike_trains_backward = zeros(n_neurones, intervals);

off_set = bar_width/2;

for t = 1:intervals
    bar_loc = mod(bar_freq * t * dt, 1 + off_set) - off_set;
    bar_right = bar_loc + bar_width/2; 
    bar_left = bar_loc - bar_width/2;
    if orientation == "azimuthal"
        neurones_active = (bar_left < retinal_positions(:, 1)) .* (retinal_positions(:, 1) < bar_right);
    elseif orientation == "elevational"
        neurones_active = (bar_left < retinal_positions(:, 2)) .* (retinal_positions(:, 2) < bar_right);
    else
        error('Check that orientation is either azimuthal or elevational')
    end
    spikes = neurones_active .* (rand(n_neurones, 1) < dt * firing_rate);
    spike_trains_backward(:, t) = spikes;
end

for t = 1:intervals
    bar_loc = mod(1 - bar_freq * t * dt + off_set, 1) - off_set;
    bar_right = bar_loc + bar_width/2;
    bar_left = bar_loc - bar_width/2;
    if orientation == "azimuthal"
        neurones_active = (bar_left < retinal_positions(:, 1)) .* (retinal_positions(:, 1) < bar_right);
    elseif orientation == "elevational"
        neurones_active = (bar_left < retinal_positions(:, 2)) .* (retinal_positions(:, 2) < bar_right);
    else
        error('Check that orientation is either azimuthal or elevational')
    end
    spikes = neurones_active .* (rand(n_neurones, 1) < dt * firing_rate);
    spike_trains_forward(:, t) = spikes;
end

end
        
