% Checks for collisions between nodes and obstacles or plains.

% Input:
% nodes - An array of 3D points [X, Y, Z] representing a sequence of connected nodes.
% obstacles - An array of cylindrical obstacles, where each obstacle is defined by
%             [X, Y, Z, radius, height].
% nUsedNodes - The number of nodes currently in use for collision checking.
% plains - A 2-element array [minZ, maxZ], representing the Z-axis boundaries.

% Output:
% intersects - A count of detected collisions:
%            - Increments for each node segment intersecting an obstacle.
%            - Increments for each node outside the specified plains range.

function intersects = collisionCheck(nodes,obstacles,nUsedNodes, plains)
    
    nObstacles = size(obstacles,1);
    
    intersects = 0;
    
    for i = 1 : nUsedNodes 
        for j = 1 : nObstacles
            if veccol(nodes(i,:),nodes(i+1,:),obstacles(j,:))
                intersects = intersects + 1;
                return;
            end
        end
        if (nodes(i,3) < plains(1) || nodes(i,3) > plains(2))
            intersects = intersects + 1;
        end
    end

end
