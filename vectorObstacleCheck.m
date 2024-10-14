function thereIsCollision = vectorObstacleCheck(vectors, obstacles, startPoint)

    collisionCounter = 0;
    numVectors = size(vectors, 1);

    for i = 1:numVectors
        currVector = vectors(i, :);
        
        for j = 1:size(obstacles, 1)
            if veccol(startPoint, currVector, obstacles(j,:))
                collisionCounter = collisionCounter + 1;
                break;
            end
        end
    end

    thereIsCollision = (collisionCounter > 0);
end

function isColliding = veccol(startPoint, endPoint, obstacle)

    obstaclePos = obstacle(1:3);
    radius = obstacle(4);
    length = obstacle(5);
    
    cylinderBottom = obstaclePos(3);
    cylinderTop = cylinderBottom - length;


    %checking if startPoint's or endPoint's x and y are within the cylinder's radius and z is within height range
    %UNNECESSARY.......
    % if (startPoint(1) < obstacle(1) + obstacle(4) && startPoint(1) > obstacle(1) - obstacle(4)) && (startPoint(2) < obstacle(2)+obstacle(4) && startPoint(2) > obstacle(2)-obstacle(4)) && (startPoint(3) > cylinderTop && startPoint(3) < cylinderBottom)
    %     isColliding = true;
    %     return;
    % end
    % if (endPoint(1) < obstacle(1) + obstacle(4) && endPoint(1) > obstacle(1) - obstacle(4)) && (endPoint(2) < obstacle(2)+obstacle(4) && endPoint(2) > obstacle(2)-obstacle(4)) && (endPoint(3) > cylinderTop && endPoint(3) < cylinderBottom)
    %     isColliding = true;
    %     return;
    % end
    
    %vector from startPoint to endPoint
    lineVector = endPoint - startPoint;
    lineLength = norm(lineVector);
    
    if lineLength == 0
        isColliding = false;
        return;
    end
    
    direction = lineVector / lineLength;
    
    %vector from startPoint to obstacles center.
    %this vector is 2 dimensional because we check the height separately
    %after.
    d = obstaclePos(1:2) - startPoint(1:2);

    %projecting the d vector to the line, then getting the closest point to
    %the obstacles center from that projection
    projLength = dot(d, direction(1:2));
    closestPointOnLine = startPoint + projLength * direction;

    %if projection is lower than the limit, startPoint is the closest
    %if projection is bigger than the limit, the endPoint is the closest
    if projLength < 0
        closestPointOnLine = startPoint;
    elseif projLength > lineLength
        closestPointOnLine = endPoint;
    end

    %distance with closestPoint from cylinder.
    distanceToCylinder = norm(closestPointOnLine(1:2) - obstaclePos(1:2));

    %if the closest point is within the height range
    isWithinHeight = closestPointOnLine(3) >= cylinderBottom && closestPointOnLine(3) <= cylinderTop;
    
    %if it is within the height range, and the distance is smaller than the
    %radius, there is a collision
    isColliding = distanceToCylinder <= radius && isWithinHeight;

    %upon closer look, we know if its inside the obstacle.
end