function intersections = collisionCheck(conf)
    global op;
    intersections = 0;
    for i = 1:size(conf,1)
        if conf(i,3)==0
            nUsedLinks = i-1;
            break;
        end
    end

    nodes = solveForwardKinematics3D(conf,op.home_base,0);
    nUsedNodes = nUsedLinks + 1;
    
    obstacles = op.obstacles;
    nObstacles = size(obstacles,1);

    for i = 1 : nUsedNodes - 1 
        for j = 1 : nObstacles
            intersections = intersections + doIntersect(nodes(i,:),nodes(i+1,:),obstacles(j,:));
        end
    end
end

function intersect = doIntersect(startPt,endPt,obstacle)

end