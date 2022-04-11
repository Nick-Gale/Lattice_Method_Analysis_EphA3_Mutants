function params = find_prob_subgraph(params,direction)
% This determines the lower bound (the minimum number of points that must 
% be removed) in order to have a graph with no crossings by using linear 
% programming. It does not have a criterion to ensure the graph is
% connected.

    if strcmp(direction, 'CTOF')
        sets_of_intersections = params.CTOF.sets_of_intersections;
        candidates = 1:params.CTOF.numpoints;
        takeout = params.CTOF.takeout;
    end
    
    if strcmp(direction, 'FTOC')
        sets_of_intersections = params.FTOC.sets_of_intersections;
        candidates = 1:params.FTOC.numpoints;
        takeout = params.FTOC.takeout;
    end
    
    
    candidates = setdiff(candidates,takeout);
    N = size(candidates,2);
    num_sets = size(sets_of_intersections,1);
    A = zeros(num_sets,N);
    for i = 1:num_sets
        A(i,sets_of_intersections(i,:)) = -1;
    end

    b = ones(num_sets,1).*(-1);
    f = ones(N,1);
    lb = zeros(N,1);
    ub = ones(N,1);
    LX = linprog(f,A,b,[],[],lb,ub);
    lower_bound = sum(LX);
    
    if strcmp(direction,'CTOF')
        params.stats.CTOF.lower_bound = lower_bound;
    end
    if strcmp(direction,'FTOC')
        params.stats.FTOC.lower_bound = lower_bound;
    end