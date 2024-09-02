% Initialize a random individual/chromosome
%
% INPUT: 
% 'op' is the object describing the optimization problem 
%
% OUTPUT: 
% 'chrom' is the random chromosome [t*2+1 x n+5]
function [chrom] =  generateRandomChromosome()
    
    global op;  % optimization problem
    global eas;
    % lengths is shared for each configuration of the robot, so it is generated only once
    lengths = zeros(1,op.n_nodes+eas.extra_genes);
    for i=1:1:op.n_nodes
        lengths(i) = (op.length_domain(2)-op.length_domain(1))*rand + op.length_domain(1);
    end   
    
    n_targets = size(op.targets,1);
    chrom = zeros(n_targets*2+1,op.n_nodes+eas.extra_genes);
    
    for i=1:1:n_targets*2        
        
        end_effector = op.home_base(1:2);
        robot_orientation = [1 0 0];
        robot = zeros(1,op.n_nodes+eas.extra_genes); 
        for j=1:1:op.n_nodes   
            % generate angles for each node
            % each angle is generated in a range that avoids collision with obstacles
            if j==1 
                % first link might be fixed to the base
                if op.first_angle.is_fixed == false
                    if(eas.obstacle_avoidance == true)
                        angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179 180], false);
                    else
                        angle = (180-(-179))*rand + (-179); % does not consider obstacle avoidance
                    end
                else
                    if(eas.obstacle_avoidance == true)
                       angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false);
                    else
                       angle = op.first_angle.angle;  % does not consider obstacle avoidance
                    end
                end
            else                
                 if(eas.obstacle_avoidance==true)
                     angle = getRandomAngleAvoidingObstacles(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, op.angle_domain, false);
                 else
                     angle = (op.angle_domain(mod(i,2)+1,2)-op.angle_domain(mod(i,2)+1,1))*rand + op.angle_domain(mod(i,2)+1,1); % does not consider obstacle avoidance
                 end
            end

            robot(j) = angle;
            
        end
        chrom(i,:) = robot;   
    end
    chrom(n_targets*2+1,:) = lengths; 
end

% A single chromosome is a matrix [t*2+1 x n+5]: %%EMİR this needs to
% change

%  |                 |         |         |         |         |
%  |     (t*2 x n)   | (t x 1) | (t x 1) | (t x 1) | (t x 1) |
%  |      angles     | segment | segment | segment |  last   |  last   |
%  |                 |  node   |  node   |   node  |  joint  |  link   |
%  |                 |  index  |  angle  |  angle  |  index  | length  |
%  |                 |         |  on X   |   on Y  |         |         |
%   ----------------- --------- --------- --------- --------- 
%  |                 |         |         |         |         |
%  |     (1 x n)     |  (1x1)  |  (1x1)  |  (1x1)  |  (1x1)  |
%  |  link lengths   |  empty  |  empty  |  empty  |  empty  |
%  |                 |         |         |         |         |
%
%        robot            extra genes of the
%    configurations           chromosome
%
% extra genes:
% - index of node on the target's orientation segment
% - angle around x to align to the orientation segment
% - angle around y to align to the orientation segment
% - index of last joint (the node before the end effector)
% - last link length