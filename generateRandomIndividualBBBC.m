% Initialize a random individual/chromosome
%
% INPUT: 
% 'op' is the object describing the optimization problem 
%
% OUTPUT: 
% 'indv' is the random individual [t*2+1 x n+eas.extra_genes]
function [indv] =  generateRandomIndividualBBBC(cMass, gen)
    
    global op;  % optimization problem
    global eas;

    % lengths are shared for each configuration of the robot, so it is generated only once
    lengths = zeros(1,op.n_links+eas.extra_genes);
    
    n_targets = size(op.targets,1);
    for i=1:op.n_links
        lengths(i) = cMass(n_targets*2+1,i) + (op.length_domain(2)*(-1 + 2*rand()))/gen;
        lengths(i) = max(min(lengths(i), op.length_domain(2)), op.length_domain(1));
    end   
     

    indv = zeros(n_targets*2+1,op.n_links+eas.extra_genes);    
    for i=1:n_targets*2      
        end_effector = op.home_base(1:2);
        robot_orientation = [1 0 0];
        robot = zeros(1,op.n_links+eas.extra_genes); 
        
        for j=1:1:op.n_links   
            % generate angles for each node
            % each angle is generated in a range that avoids collision with obstacles
            if j==1
                % first link might be fixed to the base
                if op.first_angle.is_fixed == false
                    if(eas.obstacle_avoidance == true)
                        angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179 180], false, gen, cMass, i, j);
                    else
                        % does not consider obstacle avoidance
                        angle = cMass(i,j) + (180*(-1 + (1--1)*rand()))/gen;
                        angle = max(min(angle, 180), -179);
                    end
                else
                    if(eas.obstacle_avoidance == true)
                       angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false, gen, cMass, i, j);
                    else
                       angle = op.first_angle.angle;  % does not consider obstacle avoidance
                    end
                end
            else                
                 if(eas.obstacle_avoidance==true)
                     angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, op.angle_domain, false, gen, cMass, i, j);
                 else
                     angle = cMass(i,j) + (180*(-1 + (1--1)*rand()))/gen;
                     angle = max(min(angle, 180), -179);
                 end
            end
            robot(j) = angle;
        end
        indv(i,:) = robot;   
    end
    indv(n_targets*2+1,:) = lengths;

end

% A single individual is a matrix [t*2+1 x n+extra_genes]:

%  |                 |         |         |         |         |
%  |     (t*2 x n)   | (t x 2) | (t x 2) | (t x 2) | (t x 2) |
%  |      angles     | segment | segment |  last   |  last   |
%  |                 |  node   |  node   |  joint  |  link   |
%  |                 |  index  |  angle  |  index  | length  |
%  |                 |         |         |         |         |
%   ----------------- --------- --------- --------- --------- 
%  |                 |         |         |         |         |
%  |     (1 x n)     |  (1x1)  |  (1x1)  |  (1x1)  |  (1x1)  |
%  |  link lengths   |  empty  |  empty  |  empty  |  empty  |
%  |                 |         |         |         |         |
%
%        robot                 extra genes 
%
% extra genes:
% - index of node on the target's orientation segment
% - angle to align to the orientation segment
% - index of last joint (the node before the end effector)
% - last link length