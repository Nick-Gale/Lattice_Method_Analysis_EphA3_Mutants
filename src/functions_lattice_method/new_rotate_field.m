function new_field_positions = new_rotate_field(field_points, rotation_angle)
  X=field_points(:,1);
  Y=field_points(:,2);
  
  X1=X-mean(X);
  Y1=Y-mean(Y);

  X2 = X1*cosd(rotation_angle)-Y1*sind(rotation_angle);
  Y2 = X1*sind(rotation_angle)+Y1*cosd(rotation_angle);

  X3=X2+mean(X);
  Y3=Y2+mean(Y);

  new_field_positions(:,1) = X3(:);
  new_field_positions(:,2) = Y3(:);