% This function solves the forward kinematics of a 3d soft growing robot given angles and link lengths
%
% INPUT:
% 'robot_PC' nx3 contains the configuration of a soft robot in polar coordinates, for each joint: rotation on x, rotation on y, length of the link
% 'home_base' 1x3 contains the coordinates x,y,z of the container. robot will grow in z direction
% 'draw_plot' is a boolean flag, true if you want to plot the segments from targets
%
% OUTPUT:
% 'robot_CC' (n+1)x3 contains the configuration of a soft robot in cartesian coordinates, for each joint: x, y, z (starting from home base, last one is the end effector)
% 'u' 1x3 is the unit vector of the end effector's orientation
function [robot_CC, u] = solveForwardKinematics3D(robot_PC, home_base, draw_plot)

    if draw_plot==true
        f = figure;
        hold on;
        axis equal;
        grid on;
        xlabel('x');
        ylabel('y');
        zlabel('z');
        xlim([-400 400]);
        ylim([-400 400]);
        zlim([-100 1000]);
        draw home
        plot3(0,0,0,'--gs','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b');
    end

    n_joints = size(robot_PC,1);
    robot_CC = zeros(n_joints+1, 3);
    robot_CC(1,:) = home_base(1:3);

    running_sum_angles = robot_PC(:,1:2);
    for i=2:n_joints
        running_sum_angles(i,:) = running_sum_angles(i,:) + running_sum_angles(i-1,:);  
    end 

    for i=1:n_joints
        alpha = deg2rad(running_sum_angles(i, 1));
        beta = deg2rad(running_sum_angles(i, 2));

        robot_CC(i+1,1) = sin(beta) * robot_PC(i,3);
        robot_CC(i+1,2) = -sin(alpha) * cos(beta) * robot_PC(i,3);
        robot_CC(i+1,3) = cos(alpha) * cos(beta) * robot_PC(i,3);
    end

    for i=2:n_joints+1
        robot_CC(i,:) = robot_CC(i,:) + robot_CC(i -1,:);
    end 

    u = (robot_CC(n_joints+1,:) - robot_CC(n_joints,:))/norm(robot_CC(n_joints+1,:) - robot_CC(n_joints,:)); % orientation of the end effector

    
    if draw_plot==true
        for i=2:1:n_joints+1
            plot3([robot_CC(i-1,1),robot_CC(i,1)],[robot_CC(i-1,2),robot_CC(i,2)],[robot_CC(i-1,3),robot_CC(i,3)],'-o','Color','r');
        end
        f.CurrentAxes.ZDir = 'Reverse';
        cameratoolbar('SetCoordSys','x');
        view(48.5877551020408,31.2);
%         hAxis = gca;
%         hAxis.XRuler.FirstCrossoverValue  = 0; % X crossover with Y axis
%         hAxis.XRuler.SecondCrossoverValue  = 0; % X crossover with Z axis
%         hAxis.YRuler.FirstCrossoverValue  = 0; % Y crossover with X axis
%         hAxis.YRuler.SecondCrossoverValue  = 0; % Y crossover with Z axis
%         hAxis.ZRuler.FirstCrossoverValue  = 0; % Z crossover with X axis
%         hAxis.ZRuler.SecondCrossoverValue = 0; % Z crossover with Y axis
    end
    
end