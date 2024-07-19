function coordinates = solveForwardKinematics(conf,home_base,draw)
    % Input:
    % transformations: Nx3 matrix where each row is [rotX, rotY, extZ]
    % Output:
    % coordinates: Nx3 matrix where each row is [x, y, z]
    
    % Number of transformations
    num_links = size(conf, 1);
    
    % Initialize coordinates matrix
    coordinates = zeros(num_links+1, 3);
    
    % Initial position
    accXcor = home_base(1);
    accYcor = home_base(2);
    accZcor = home_base(3);
    accRotX = home_base(4);
    accRotY = home_base(5);
    for i = 1:num_links
        % Extract current transformation
        accRotX = conf(i, 1) + accRotX;
        accRotY = conf(i, 2) + accRotY;
        extZ = conf(i, 3);
        pointFromZero = [0 0 extZ];
        % Create rotation matrices
        Rx = [1, 0, 0; 0, cosd(accRotX), -sind(accRotX); 0, sind(accRotX), cosd(accRotX)];
        Ry = [cosd(accRotY), 0, sind(accRotY); 0, 1, 0; -sind(accRotY), 0, cosd(accRotY)];
        
        % Apply rotations
        newPointFromZero = (Rx * Ry * pointFromZero')';
        
        % Apply extension
        newPoint = newPointFromZero + [accXcor, accYcor, accZcor];
        accXcor = newPoint(1);
        accYcor = newPoint(2);
        accZcor = newPoint(3);

        
        % Store new position in coordinates matrix
        coordinates(i+1, :) = newPoint;
    end
end
