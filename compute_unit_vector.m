function u = compute_unit_vector(input)
    % Extract rotation angles
    rot_x = input(4); % Rotation around x-axis in degrees
    rot_y = input(5); % Rotation around y-axis in degrees
    
    % Convert angles from degrees to radians
    rot_x_rad = deg2rad(rot_x);
    rot_y_rad = deg2rad(rot_y);
    
    % Rotation matrix for x-axis
    R_x = [1, 0, 0;
           0, cos(rot_x_rad), -sin(rot_x_rad);
           0, sin(rot_x_rad), cos(rot_x_rad)];
    
    % Rotation matrix for y-axis
        R_y = [cos(rot_y_rad), 0, sin(rot_y_rad);
           0, 1, 0;
           -sin(rot_y_rad), 0, cos(rot_y_rad)];
    
    % Combined rotation matrix (first rotate around y, then around x)
    R =  R_y*R_x;
    
    % Initial unit vector along the z-axis
    initial_vector = [0 0 1];
    
    % Apply rotation
    rotated_vector = R * initial_vector';
    
    % Normalize the resulting vector to get the unit vector
    u = rotated_vector / norm(rotated_vector);
    u(1) = round(u(1),3);
    u(2) = round(u(2),3);
    u(3) = round(u(3),3);
    u = u';
end
