function thereIsCollision = vectorObstacleCheck(vectors, obstacles, startPoint)

    numVectors = size(vectors, 1);

    for i = 1:numVectors
        currVector = vectors(i, :);
        
        for j = 1:size(obstacles, 1)
            if veccol(startPoint, currVector, obstacles(j,:))
                thereIsCollision = true;
                return;
            end
        end
    end
    thereIsCollision = false;
end

