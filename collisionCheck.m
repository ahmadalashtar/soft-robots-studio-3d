function intersects = collisionCheck(conf, nodes, obstacles)
    nObstacles = size(obstacles,1);
    
    nUsedLinks = 0;
    for i = 1:size(conf,1)
        if conf(i,3)==0
            nUsedLinks = i-1;
            break;
        end
    end

    nUsedNodes = nUsedLinks + 1;

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