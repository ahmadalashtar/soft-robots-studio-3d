function coordinates = solveForwardKinematics3D(conf, base, draw)
    % Number of transformations
    num_links = size(conf, 1);
    
    % Initialize coordinates matrix
    coordinates = zeros(num_links+1, 3);
    
    R = eye(3);
    % Initial position
    x = base(1);
    y = base(2);
    z = base(3);

    rotx = base(4);
    roty = base(5);

    Rx = [1, 0, 0; 0, cosd(rotx), -sind(rotx); 0, sind(rotx), cosd(rotx)];
    Ry = [cosd(roty), 0, sind(roty); 0, 1, 0; -sind(roty), 0, cosd(roty)];
    R = R*Rx*Ry;
    % Apply rotations
    tcp_coordinates = (R * [0 0 0]')';
    
    % Apply extension
    new_coordinates = tcp_coordinates + [x, y, z];
    
    % Store new position in coordinates matrix
    coordinates(1, :) = new_coordinates;



    for i = 1:num_links
        rotx = conf(i,1);
        roty = conf(i,2);
        growth = conf(i,3);

        Rx = [1, 0, 0; 0, cosd(rotx), -sind(rotx); 0, sind(rotx), cosd(rotx)];
        Ry = [cosd(roty), 0, sind(roty); 0, 1, 0; -sind(roty), 0, cosd(roty)];
        R = R*Rx*Ry;
        % Apply rotations
        tcp_coordinates = (R * [0 0 growth]')';
        
        % Apply extension
        new_coordinates = tcp_coordinates + [x, y, z];
        x = new_coordinates(1);
        y = new_coordinates(2);
        z = new_coordinates(3);

        
        % Store new position in coordinates matrix
        coordinates(i+1, :) = new_coordinates;
        
    end
end
