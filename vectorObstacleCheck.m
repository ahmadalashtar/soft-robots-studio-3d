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

