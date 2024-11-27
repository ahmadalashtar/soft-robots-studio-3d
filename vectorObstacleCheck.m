function thereIsCollision = vectorObstacleCheck(vectors, obstacles, startPoint)

    numVectors = size(vectors, 1);

    for i = 1:numVectors
        currVector = vectors{i}(:);
        currVector = [currVector(1), currVector(2), currVector(3)];
        
        for j = 1:size(obstacles, 1)
            if segmentxcylinder(startPoint, currVector, obstacles(j,:))
                thereIsCollision = true;
                return;
            end
        end
    end
    thereIsCollision = false;
end

