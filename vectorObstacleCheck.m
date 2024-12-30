% This function checks if any of the path vectors intersect with any obstacle.

% Input:
% vectors: A cell array of 3D vectors to be checked for collisions.
% obstacles: An array where each row represents a 3D obstacle.
% startPoint: The starting point of the vectors (3D vector).

% Output:
% thereIsCollision: A boolean value indicating if any of the path vectors collide with an obstacle.

function thereIsCollision = vectorObstacleCheck(vectors, obstacles, startPoint)

    numVectors = size(vectors, 1);

    for i = 1:numVectors
        currVector = vectors{i}(:);
        currVector = [currVector(1), currVector(2), currVector(3)];
        
        for j = 1:size(obstacles, 1)
            if veccol(startPoint, currVector, obstacles(j,:))
                thereIsCollision = true;
                return;
            end
        end
    end
    thereIsCollision = false;
end

