function [CTOF_full_field_positions, CTOF_full_collicular_positions, FTOC_full_field_positions, FTOC_full_collicular_positions] = anatomical_map(idxs, collicular_connections,  collicular_positions_RC, collicular_positions_ML, retinal_positions_NT, retinal_positions_DV)

%useful to convert the collicular connections into a matrix with collicular connections in the first index, retinal connections in the second
connection_matrix = zeros(length(collicular_positions_RC), length(retinal_positions_NT));
idxs = idxs;
for i = 1:length(collicular_positions_RC)
   indexes = intersect(collicular_connections(:, i), idxs);
   non_zero = indexes(indexes ~= 0);
   %colliculus indexes are in the rows, retinal connections are in the columnss
   for j = 1:length(indexes)
      if indexes(j) > 0
         connection_matrix(i, indexes(j)) = connection_matrix(i, indexes(j)) + 1;
      end
   end
end

% Calculate the CtoF field positions as the average of the retinal position for each collicular position

inds = sum(connection_matrix, 2);
inds(inds == 0) = 1;

mean_nt = (connection_matrix * retinal_positions_NT) ./ inds;
mean_dv = (connection_matrix * retinal_positions_DV) ./ inds;

CTOF_full_field_positions(:, 1) = mean_nt;
CTOF_full_field_positions(:, 2) = mean_dv;

CTOF_full_collicular_positions(:, 1) = collicular_positions_RC(idxs);
CTOF_full_collicular_positions(:, 2) = collicular_positions_ML(idxs);

% Calculate the FtoC field positions as the average of the collicular position for each retinal position
inds = sum(connection_matrix, 1);
inds(inds == 0) = 1;

mean_rc = ((collicular_positions_RC' * connection_matrix) ./ inds)';
mean_ml = ((collicular_positions_ML' * connection_matrix) ./ inds)';


FTOC_full_field_positions(:, 1) = retinal_positions_NT(idxs);
FTOC_full_field_positions(:, 2) = retinal_positions_DV(idxs);

FTOC_full_collicular_positions(:, 1) = mean_rc(idxs);
FTOC_full_collicular_positions(:, 2) = mean_ml(idxs);
















%if any contacts had an NaN
% CTOF_full_field_positions(isnan(CTOF_full_field_positions)) = 0;
% CTOF_full_field_positions(isnan(CTOF_full_field_positions)) = 0;

% CTOF_full_field_positions(isinf(CTOF_full_field_positions)) = 0;
% CTOF_full_field_positions(isinf(CTOF_full_field_positions)) = 0;

% CTOF_full_collicular_positions(isnan(CTOF_full_field_positions)) = 0;
% CTOF_full_collicular_positions(isnan(CTOF_full_field_positions)) = 0;

% CTOF_full_collicular_positions(isinf(CTOF_full_field_positions)) = 0;
% CTOF_full_collicular_positions(isinf(CTOF_full_field_positions)) = 0;


% %if any contacts had an NaN
% FTOC_full_field_positions(isnan(FTOC_full_field_positions)) = 0;
% FTOC_full_field_positions(isnan(FTOC_full_field_positions)) = 0;

% FTOC_full_field_positions(isinf(FTOC_full_field_positions)) = 0;
% FTOC_full_field_positions(isinf(FTOC_full_field_positions)) = 0;

% FTOC_full_collicular_positions(isnan(FTOC_full_collicular_positions)) = 0;
% FTOC_full_collicular_positions(isnan(FTOC_full_collicular_positions)) = 0;

% FTOC_full_collicular_positions(isinf(FTOC_full_collicular_positions)) = 0;
% FTOC_full_collicular_positions(isinf(FTOC_full_collicular_positions)) = 0;