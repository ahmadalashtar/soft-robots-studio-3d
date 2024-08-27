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
