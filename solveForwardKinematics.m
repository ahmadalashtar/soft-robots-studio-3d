function coordinates = solveForwardKinematics(transformations,home_base,draw)
    % Input:
    % transformations: Nx3 matrix where each row is [rotX, rotY, extZ]
    % Output:
    % coordinates: Nx3 matrix where each row is [x, y, z]
    
    % Number of transformations
    numTransforms = size(transformations, 1);
    
    % Initialize coordinates matrix
    coordinates = zeros(numTransforms+1, 3);
    
    % Initial position
    currentPos = home_base(1:3);
    
    for i = 1:numTransforms
        % Extract current transformation
        rotX = transformations(i, 1);
        rotY = transformations(i, 2);
        extZ = transformations(i, 3);
        
        % Create rotation matrices
        Rx = [1, 0, 0; 0, cosd(rotX), -sind(rotX); 0, sind(rotX), cosd(rotX)];
        Ry = [cosd(rotY), 0, sind(rotY); 0, 1, 0; -sind(rotY), 0, cosd(rotY)];
        
        % Apply rotations
        rotatedPos = (Rx * Ry * currentPos')';
        
        % Apply extension
        newPos = rotatedPos + [0, 0, extZ];
        
        % Update current position
        currentPos = newPos;
        
        % Store new position in coordinates matrix
        coordinates(i+1, :) = newPos;
    end
end
