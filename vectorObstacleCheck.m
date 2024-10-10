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
    cylinderTop = cylinderBottom + length;

    lineVector = endPoint - startPoint;
    lineLength = norm(lineVector);
    
    if lineLength == 0
        isColliding = false;
        return;
    end
    
    direction = lineVector / lineLength;
    
    d = obstaclePos(1:2) - startPoint(1:2);
    projLength = dot(d, direction(1:2));
    
    closestPointOnLine = startPoint + projLength * direction;

    if projLength < 0
        closestPointOnLine = startPoint;
    elseif projLength > lineLength
        closestPointOnLine = endPoint;
    end

    distanceToCylinder = norm(closestPointOnLine(1:2) - obstaclePos(1:2));

    isWithinHeight = closestPointOnLine(3) >= cylinderBottom && closestPointOnLine(3) <= cylinderTop;

    isColliding = distanceToCylinder <= radius && isWithinHeight;
end