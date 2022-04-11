function D = compute_dist(W, P) 
% COMPUTE_DIST - Compute all possible pairs of distances between sets of 2D vectors
%   
%   COMPUTE_DIST(W, P) - For an S by 2 matrix W, and a 2 by Q matrix
%     P, produce an S-by-Q matrix of distances between the S 2D
%     vectors in W and the Q 2D vectors in P.
%   
%   COMPUTE_DIST(P) - For a 2 by Q matrix P, produce an Q-by-Q matrix
%     of distances between each pair of the Q 2D vectors in P.
%

if (nargin == 1)
    P = W;
    W = transpose(W);
end
% W is S by 2
% P is 2 by Q
% Number of vectors
    S = size(W, 1);
    R = size(W, 2);
    if (R ~= 2)
        error(['W does not have 2 columns'])
    end
    if (size(P, 1) ~= R)
        error(['P does not have same number of rows as W has ' ...
               'columns'])
    end
    Q = size(P, 2);
    
    % X and Y components
    XA = repmat(W(:,1), 1, Q);          % S by Q
    XB = repmat(P(1,:), S, 1);
    YA = repmat(W(:,2), 1, Q);
    YB = repmat(P(2,:), S, 1);
    
    % Find distances
    D = sqrt((XA - XB).^2 + (YA - YB).^2);
end
