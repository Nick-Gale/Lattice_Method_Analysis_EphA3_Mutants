function true = doescross(edge1,edge2,point_coords)
%Return 1 if the points intersect, otherwise return 0. Copied from some R
%code from David Sterratt.

    L1_coords = point_coords(edge1,:);
    L2_coords = point_coords(edge2,:);
    L1_x1 = L1_coords(1,1);
    L1_y1 = L1_coords(1,2);
    L1_x2 = L1_coords(2,1);
    L1_y2 = L1_coords(2,2);
    L2_x3 = L2_coords(1,1);
    L2_y3 = L2_coords(1,2);
    L2_x4 = L2_coords(2,1);
    L2_y4 = L2_coords(2,2);
    x1x2 = L1_x1 - L1_x2;
    x3x4 = L2_x3 - L2_x4;
    y1y2 = L1_y1 - L1_y2;
    y3y4 = L2_y3 - L2_y4;
    dx12y12 = det([L1_x1, L1_y1; L1_x2, L1_y2]);
    dx34y34 = det([L2_x3, L2_y3; L2_x4, L2_y4]);
    D = det([x1x2, y1y2; x3x4,y3y4]);
    
    if D~= 0 
        intersection_x = det([dx12y12, x1x2; dx34y34, x3x4])/D;
        intersection_y = det([dx12y12, y1y2; dx34y34, y3y4])/D;
    else
        true = 0;
        return
    end
    
    %determine if the intersection lies on the line
    on_L1 = intersection_x >= min(L1_x1,L1_x2) & intersection_x <= max(L1_x1,L1_x2) & intersection_y >= min(L1_y1, L1_y2) & intersection_y <= max(L1_y1,L1_y2);
    on_L2 = intersection_x >= min(L2_x3,L2_x4) & intersection_x <= max(L2_x3,L2_x4) & intersection_y >= min(L2_y3, L2_y4) & intersection_y <= max(L2_y3,L2_y4);
    if on_L1 == 1 & on_L2 == 1
        true = 1;
    else
        true = 0;
    end