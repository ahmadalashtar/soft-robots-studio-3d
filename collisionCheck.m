function intersections = collisionCheck(conf)
    global op;
    
    obstacles = op.obstacles;
    nObstacles = size(obstacles,1);

    nodes = solveForwardKinematics3D(conf,op.home_base,0);

    for i = 1:size(conf,1)
        if conf(i,3)==0
            nUsedLinks = i-1;
            break;
        end
    end
    
    nUsedNodes = nUsedLinks + 1;

    intersections = 0;
    for i = 1 : nUsedNodes - 1 
        for j = 1 : nObstacles
            intersections = intersections + doTheyIntersect(nodes(i,:),nodes(i+1,:),obstacles(j,:));
        end
    end
end

function intersect = doTheyIntersect(startPt,endPt,obstacle)

end

function intersects = segmentIntersectsCircle(segment,circle)
    point1 = segment(1,:);
    point2 = segment(2,:);
    center = circle(1:2);
    centerToSegmentDistance = pointToSegment3D(center,point1,point2);

    radius = circle(3);
    
    if centerToSegmentDistance > radius
        intersects = false;
    else
        intersects = true;
    end
end