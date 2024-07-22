function [theta_x, theta_y] = solveInverseKinematics(v)
    % Input: 
    % v - a 1x3 vector [x, y, z]

    % Normalize the input vector
    v = v / norm(v);
    
    % Extract components
    x = v(1);
    y = v(2);
    z = v(3);
    
    % Calculate theta_x to rotate the vector into the yz-plane
    % The rotation matrix for rotation around x-axis:
    % Rx(theta_x) = [1, 0, 0;
    %                0, cos(theta_x), -sin(theta_x);
    %                0, sin(theta_x), cos(theta_x)]
    % After rotation, the vector should be [x, y*cos(theta_x) - z*sin(theta_x), y*sin(theta_x) + z*cos(theta_x)]
    % We want to nullify the x component, so we find theta_x such that x = 0.
    theta_x = atan2(y, z);
    
    % Rotate vector around x-axis
    R_x = [1, 0, 0;
           0, cos(theta_x), -sin(theta_x);
           0, sin(theta_x), cos(theta_x)];
    v_rot_x = R_x * v';
    
    % Calculate theta_y to align the rotated vector with the z-axis
    % The rotation matrix for rotation around y-axis:
    % Ry(theta_y) = [cos(theta_y), 0, sin(theta_y);
    %                0, 1, 0;
    %               -sin(theta_y), 0, cos(theta_y)]
    % After rotation, the vector should be [y*sin(theta_y) + z*cos(theta_y), 0, y*cos(theta_y) - z*sin(theta_y)]
    % We want the x component to be zero, so we find theta_y such that y*sin(theta_y) + z*cos(theta_y) = 0.
    v_rot_x = v_rot_x'; % Transpose to column vector
    theta_y = atan2(-v_rot_x(1), v_rot_x(3));
    
    % Convert angles to degrees for better interpretation (optional)
    theta_x = -rad2deg(theta_x);
    theta_y = -rad2deg(theta_y);
end
