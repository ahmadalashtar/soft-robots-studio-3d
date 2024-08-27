function [theta_x, theta_y, length] = solveInverseKinematics3D(conf,points,ee_link,target)
 
    R = eye(1);

    for j = ee_link:-1:1
        Rx = [1, 0, 0; 0, cosd(-conf(j,1)), -sind(-conf(j,1)); 0, sind(-conf(j,1)), cosd(-conf(j,1))];
        Ry = [cosd(-conf(j,2)), 0, sind(-conf(j,2)); 0, 1, 0;-sind(-conf(j,2)), 0, cosd(-conf(j,2))];
        R = R*Ry*Rx;
    end
    
    ee_point = points(ee_link+1,:);
    ee_point_rotated = (R*ee_point')';
    target_rotated = (R*target(1:3)')';
    target_rotated_from_zero = target_rotated - ee_point_rotated;
    [theta_x, theta_y, length] = calculateAngle(target_rotated_from_zero);
    
end

function [rotx, roty, length] = calculateAngle(v)
    length = norm(v);

    x = v(1);
    y = v(2);
    z = v(3);
    
    theta_x = rad2deg(atan2(y, z));
    
    R_x = [1, 0, 0;
           0, cosd(theta_x), -sind(theta_x);
           0, sind(theta_x), cosd(theta_x)];
    v_rot_x = (R_x * v')';
    
    theta_y = -rad2deg(atan2(v_rot_x(1), v_rot_x(3)));
    
    rotx = -theta_x;
    roty = -theta_y;

end