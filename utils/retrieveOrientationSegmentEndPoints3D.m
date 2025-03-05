function [endPoints] = retrieveOrientationSegmentEndPoints3D(targets, obstacles, base, xAngles, yAngles)

    maxLength = retrieveMaxLength(targets, base);

    n_targets = size(targets, 1);

    intersections(n_targets) = struct('Obstacles', [], 'StopsAt', []);
    targetsUnitVectors = zeros(size(targets, 1), 3);

    for i = 1:n_targets
        startPoint = targets(i, 1:3);
        
        % Compute the unit vector with angles
        u = compute_unit_vector_with_angles(xAngles(i), yAngles(i));
        targetsUnitVectors(i, :) = u;
        
        % Calculate the endpoint considering angles
        endPoint = targets(i, 1:3) - u * maxLength;
        
        for j = 1:size(obstacles, 1)
            obstacle = obstacles(j, :);
            if segmentxcylinder(startPoint, endPoint, obstacle)
                intersections(i).Obstacles = [intersections(i).Obstacles j];
            end
        end
    end
    
    endPoints = targets(:, 1:3) - targetsUnitVectors * maxLength;

    for i = 1 : n_targets
        if isempty(intersections(i).Obstacles)
            continue;
        end
        obstacleIndices = intersections(i).Obstacles;
        intersections(i).StopsAt = nearestObstacleIDfromTarget(i, obstacleIndices, targets, obstacles);
        stopsAtObstacleIndex = intersections(i).StopsAt;
        target = targets(i, 1:3);
        endPoint = endPoints(i, :);
        obstacle = obstacles(stopsAtObstacleIndex, :);
        endPoints(i, 1:3) = retrieveCoordinates(target, endPoint, obstacle);
    end
end

% Function to compute unit vector based on angles (in degrees)
function u = compute_unit_vector_with_angles(xAngle, yAngle)
    % Convert angles to radians
    xAngleRad = deg2rad(xAngle);
    yAngleRad = deg2rad(yAngle);

    % Calculate the unit vector based on spherical coordinates (angles)
    u = [cos(yAngleRad) * cos(xAngleRad), cos(yAngleRad) * sin(xAngleRad), sin(yAngleRad)];
end

% Helper function to compute the coordinates where the target stops at the obstacle
function coordinates = retrieveCoordinates(startPt, endPt, obstacle)
    coordinates = endPt;
    [inside, ~, ~] = segmentInsideCylinder(startPt, endPt, obstacle);
    if inside
        coordinates = startPt;
        return;
    end
    
    % Calculate the intersection with the obstacle as in your original function
    % This can be reused from your original code as is
    % ...
end

% The remaining functions (e.g., nearestObstacleIDfromTarget, retrieveMaxLength) remain unchanged


function nearestObstacleIndex = nearestObstacleIDfromTarget(targetIndex,obstacleIndices,targets,obstacles)
target = targets(targetIndex,:);
collisionObstacles = obstacles(obstacleIndices,:);

minLength = Inf;
for i = 1 : size(obstacleIndices,2)
    length  = norm(target(1:2)-collisionObstacles(i,1:2));
    if length < minLength
        minLength = length;
        nearestObstacleIndex  = obstacleIndices(i);
    end
end
end

function maxLength = retrieveMaxLength(targets,base)
maxLength = 0;
for i=1:size(targets,1)
    target = targets(i,1:3);
    length = norm(base(1:3)-target);
    if length > maxLength
        maxLength = length;
    end

end
maxLength = maxLength*2/3;
end