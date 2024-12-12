function intersects = collisionCheck(nodes,obstacles,nUsedNodes, planes)

nObstacles = size(obstacles,1);

intersects = 0;

for i = 1 : nUsedNodes 
    for j = 1 : nObstacles
        if veccol(nodes(i,:),nodes(i+1,:),obstacles(j,:))
            intersects = intersects + 1;
            return;
        end
    end
    if (nodes(i,3) < planes(1) || nodes(i,3) > planes(2))
        intersects = intersects + 1;
    end
end
end