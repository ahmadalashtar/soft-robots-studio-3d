function intersects = collisionCheck(nodes,obstacles,nUsedNodes)

nObstacles = size(obstacles,1);

intersects = false;
for i = 1 : nUsedNodes - 1 
    for j = 1 : nObstacles
        if veccol(nodes(i,:),nodes(i+1,:),obstacles(j,:))
            intersects = true;
            return;
        end
    end
end

end