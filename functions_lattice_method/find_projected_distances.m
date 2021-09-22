function [link_ratios_RC, link_ratios_ML] = find_projected_distances(list_of_neighbours,from_points,to_points)

% Calculates ratios of sum of all edges along field compared to sum along coll as projected along RC and ML axis links with the wrong polarity are ignored

  
point_1 = to_points(list_of_neighbours(:,1),:);
point_2 = to_points(list_of_neighbours(:,2),:);

vec_A = point_1 - point_2;

to_distances_RC = vec_A(:,2);
to_distances_ML = vec_A(:,1);

point_1 = from_points(list_of_neighbours(:,1),:);
point_2 = from_points(list_of_neighbours(:,2),:);

vec_B = point_1 - point_2;

from_distances_RC = vec_B(:,2);
from_distances_ML = vec_B(:,1);

%% Exclude edges in wrong direction
% Changing >1 to <1 - because of field/retina difference?
I_RC = find((from_distances_RC.*to_distances_RC) < 1);

I_ML = find((from_distances_ML.*to_distances_ML) < 1);

link_ratios_RC = sum(abs(to_distances_RC(I_RC)))/sum(abs(from_distances_RC(I_RC)));
link_ratios_ML = sum(abs(to_distances_ML(I_ML)))/sum(abs(from_distances_ML(I_ML)));





