function [ML_whole, ML_sub, RC_whole, RC_sub, new_field_points] = new_single_axis_order(list_of_neighbours, points_not_in_subgraph, coll_points, field_points, field_rotation_angle, take_out)

new_field_points = new_rotate_field(field_points, field_rotation_angle);
neighbours_sg = remove_links_including_nodes(list_of_neighbours, points_not_in_subgraph);

fp = new_field_points(:,1);
cp = coll_points(:,1);

ul1 = list_of_neighbours(:,1);
ul2 = list_of_neighbours(:,2);


DISCRIM = (fp(ul1) - fp(ul2)) .* (cp(ul1) - cp(ul2));
IGOOD = find(DISCRIM < 0);
IBAD = find(DISCRIM > 0);
ML_whole = 100 * length(IGOOD) / (length(IGOOD) + length(IBAD));

DISCRIM = (fp(neighbours_sg(:,1)) - fp(neighbours_sg(:,2))) .* (cp(neighbours_sg(:,1)) - cp(neighbours_sg(:,2)));
IGOOD = find(DISCRIM < 0);
IBAD = find(DISCRIM > 0);

ML_sub = 100 * length(IGOOD) / (length(IGOOD) + length(IBAD));

%fp = params.FTOC.field_points(:,2);
fp = new_field_points(:,2);
cp = field_points(:,2);

DISCRIM = (fp(ul1) - fp(ul2)) .* (cp(ul1) - cp(ul2));
IGOOD = find(DISCRIM < 0);
IBAD = find(DISCRIM > 0);

RC_whole = 100 * length(IGOOD) / (length(IGOOD) + length(IBAD));

DISCRIM =(fp(neighbours_sg(:,1))-fp(neighbours_sg(:,2))).*(cp(neighbours_sg(:,1))-cp(neighbours_sg(:,2)));
IGOOD = find(DISCRIM < 0);
IBAD = find(DISCRIM > 0);
  

RC_sub = 100 * length(IGOOD) / (length(IGOOD) + length(IBAD));










































































































































































































