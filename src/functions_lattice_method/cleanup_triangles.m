function newtriangles = cleanup_triangles(triangles, positions, tolerance)
%Deletes triangles from a list that have an angle greater than tolerance.
%Tolerance is given in degrees.

num_triangles = size(triangles,1);
t = 0;
newtriangles = triangles;

for n=1:num_triangles
    vertices = triangles(n,:);
    side_lengths = compute_dist(positions(vertices,:),positions(vertices,:)');
    AB = side_lengths(1,2);
    AC = side_lengths(1,3);
    BC = side_lengths(2,3);
    
    cosine(1) = (AB^2+AC^2 - BC^2)/(2*AB*AC);
    cosine(2) = (AB^2+BC^2 - AC^2)/(2*AB*BC);
    cosine(3) = (AC^2+BC^2 - AB^2)/(2*AC*BC);
    angles = acosd(cosine(:));
    
    if max(angles) > tolerance
       newtriangles(n-t,:) = [];
       t = t+1;
    end
end