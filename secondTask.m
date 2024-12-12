function secondTask(exp_flag)
    global op;
    if nargin == 0
        exp_flag = 0;
    end


    t4 = [60+10 120 145];
    t5 = [120+10 60 145 ];
    t6 = [120+10 -60 145];
    t8 = [60+10 -120 145];
    op.targets = [  
                    
                    t4 -28.8 29.6;
                    t5 -32.005383208083494 25.004301778398400;
                    t6 36 30;
                    t8 28.8 29.6;

                    ]; %target [x y z ux uy uz cone_angle]
                    % ]; %target [x y z ux uy uz cone_angle]
for i = 1:size(op.targets,1)
    [rotx, roty] = getAngleForTask(op.targets(i,1:3), [0 0 50]);
    op.targets(i,4) = rotx;
    op.targets(i,5) = roty;

end
    op.obstacles = [
                    20 50 150 10 150;
                    50 20 150 10 150;
                    50 -20 150 10 150;
                    20 -50 150 10 150;
                    
                    ]; %cylinder [x y z(base) radius height]

    
    op.end_points = retrieveOrientationSegmentEndPoints3D(op.targets,op.obstacles,op.home_base);  % retrieve the end points for each target's orientation segment
    
    %%drawProblem3D([]);

   
end
function [rotx, roty] = getAngleForTask(target, obstacle)
v = target-obstacle;

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