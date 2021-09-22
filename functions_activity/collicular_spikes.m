function [spike_trains_forward, spike_trains_backward] = collicular_spikes(collicular_positions, retinal_spikes_forward, retinal_spikes_backward, retinal_adjacency, collicular_adjacency, base_firing_rate, time, dt, seed)
%retinal adjacency is row = retina, col = collicus
rng(seed, 'twister')
intervals = floor(time / dt);
n_neurones = size(collicular_positions, 1);
spike_trains_forward = zeros(n_neurones, intervals);
spike_trains_backward = zeros(n_neurones, intervals);

%retinal_adjacency(find(retinal_adjacency ~= 0))s
r_weights_forward = retinal_adjacency * retinal_spikes_forward;
r_weights_backward = retinal_adjacency * retinal_spikes_backward;

retinal_normaliser = sum(retinal_adjacency, 2);

event_count_forward = zeros(n_neurones, intervals);
event_count_backward = zeros(n_neurones, intervals);

% threshold = 0.1;
% decay = 1;

% Display the progress
   reverseStr = [];
   percentDone = 100 * 1 / intervals;
   msg = sprintf('Percent done: %3.1f', percentDone);
   fprintf([reverseStr, msg]);
   reverseStr = repmat(sprintf('\b'), 1, length(msg));


for t = 2:intervals
   % Display the progress
   percentDone = 100 * t / intervals;
   msg = sprintf('Percent done: %3.1f', percentDone);
   fprintf([reverseStr, msg]);
   reverseStr = repmat(sprintf('\b'), 1, length(msg));

   %count incoming spiking events from retina and colliculus
   event_count_forward(:, t) = event_count_forward(:, t - 1) + (r_weights_forward(:, t)  + collicular_adjacency * spike_trains_forward(:, t-1));
   event_count_backward(:, t) = event_count_backward(:, t - 1) + (r_weights_backward(:, t) + collicular_adjacency * spike_trains_backward(:, t-1));

   %generate spikes above a threshold
   spike_trains_forward(:, t) = rand(n_neurones, 1) * base_firing_rate < (event_count_forward(:, t) ./ retinal_normaliser);
   spike_trains_backward(:, t) = rand(n_neurones, 1) * base_firing_rate < (event_count_backward(:, t) ./ retinal_normaliser);


   %reset the counters
   event_count_forward(:, t) = event_count_forward(:, t) .* (~spike_trains_forward(:, t));
   event_count_backward(:, t) = event_count_backward(:, t) .* (~spike_trains_backward(:, t));

   %decay
   % event_count_forward(:, t) = decay * event_count_forward(:, t);
   % event_count_backward(:, t) = decay * event_count_backward(:, t);
end
fprintf('\n')

end

