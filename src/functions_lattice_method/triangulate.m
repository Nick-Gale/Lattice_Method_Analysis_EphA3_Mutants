function [triangles, neighbours] = triangulate(chosen_positions, candidates, tolerance)
%TRIANGULATION: delaunay triangles and list of links on given points
    triangles = delaunay(chosen_positions(candidates, 1), chosen_positions(candidates, 2));
    %triangles = cleanup_triangles(triangles, chosen_positions(candidates, :), tolerance);
    num_triangles = size(triangles,1);
    
    for i=1:num_triangles
	    neighbours(candidates(triangles(i,1)), candidates(triangles(i,2))) = 1;
        neighbours(candidates(triangles(i,2)), candidates(triangles(i,1))) = 1;
        neighbours(candidates(triangles(i,1)), candidates(triangles(i,3))) = 1;
        neighbours(candidates(triangles(i,3)), candidates(triangles(i,1))) = 1;
        neighbours(candidates(triangles(i,2)), candidates(triangles(i,3))) = 1;
        neighbours(candidates(triangles(i,3)), candidates(triangles(i,2))) = 1;
    end