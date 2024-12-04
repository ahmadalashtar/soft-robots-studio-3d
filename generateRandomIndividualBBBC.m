% Initialize a random individual/chromosome
%
% INPUT: 
% 'op' is the object describing the optimization problem 
%
% OUTPUT: 
% 'indv' is the random individual [t*2+1 x n+eas.extra_genes]
function [individual] =  generateRandomIndividualBBBC(centerOfMass, gen)
    
    global op;  % optimization problem
    global eas;

    n_targets = size(op.targets,1);
    angleLowerBound = op.angle_domain(1);
    angleUpperBound = op.angle_domain(2);
    lengthLowerBound = op.length_domain(1);
    lengthUpperBound = op.length_domain(2);
    
    individual = zeros(n_targets*2+1,op.n_links+eas.extra_genes);
    
    % for angles
    rows = n_targets*2;
    columns = op.n_links;
    individual(1:rows,1:columns) = bigBang_norm(centerOfMass(1:rows,1:columns),...
        rows,columns,angleUpperBound,angleLowerBound, gen);
    
    % for lengths
    individual(end,1:columns) = bigBang_norm(centerOfMass(end,1:columns),...
        1,columns,lengthUpperBound,lengthLowerBound, gen);

    % % lengths are shared for each configuration of the robot, so it is generated only once
    % lengths = zeros(1,op.n_links+eas.extra_genes);
    % 
    % n_targets = size(op.targets,1);
    % for i=1:op.n_links
    %     lengths(i) = cMass(end,i) + (op.length_domain(2)*(-1 + 2*rand()))/gen;
    %     lengths(i) = max(min(lengths(i), op.length_domain(2)), op.length_domain(1));
    % end   
    % 
    % 
    % indv = zeros(n_targets*2+1,op.n_links+eas.extra_genes);    
    % for i=1:n_targets*2      
    %     end_effector = op.home_base(1:2);
    %     robot_orientation = [1 0 0];
    %     robot = zeros(1,op.n_links+eas.extra_genes); 
    % 
    %     for j=1:1:op.n_links   
    %         % generate angles for each node
    %         % each angle is generated in a range that avoids collision with obstacles
    %         if j==1
    %             % first link might be fixed to the base
    %             if op.first_angle.is_fixed == false
    %                 if(eas.obstacle_avoidance == true)
    %                     angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-179 180], false, gen, cMass, i, j);
    %                 else
    %                     % does not consider obstacle avoidance
    %                     angle = cMass(i,j) + (180*(-1 + (1--1)*rand()))/gen;
    %                     angle = max(min(angle, 180), -179);
    %                 end
    %             else
    %                 if(eas.obstacle_avoidance == true)
    %                    angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, [-abs(op.first_angle.angle) abs(op.first_angle.angle)], false, gen, cMass, i, j);
    %                 else
    %                    angle = op.first_angle.angle;  % does not consider obstacle avoidance
    %                 end
    %             end
    %         else                
    %              if(eas.obstacle_avoidance==true)
    %                  angle = getRandomAngleAvoidingObstaclesWithCenterOfMass(end_effector, robot_orientation, lengths(j), op.length_domain, op.obstacles, op.angle_domain, false, gen, cMass, i, j);
    %              else
    %                  angle = cMass(i,j) + (180*(-1 + (1--1)*rand()))/gen;
    %                  angle = max(min(angle, 180), -179);
    %              end
    %         end
    %         robot(j) = angle;
    %     end
    %     indv(i,:) = robot;   
    % end
    % indv(n_targets*2+1,:) = lengths;

end

function [indv] = bigBang_norm(centerOfMass, rows,columns,upper,lower, gen)
    mu = 0;
    sigma = 1;
    % Step 1: Generate normally distributed random numbers
    randomNumbers = normrnd(mu, sigma, [rows, columns]);
    
    % Step 2: Normalize the numbers to the range [-1, 1]
    minVal = min(randomNumbers); % Find the minimum value
    maxVal = max(randomNumbers); % Find the maximum value
    
    % Normalize to [0, 1]
    normalizedNumbers = (randomNumbers - minVal) ./ (maxVal - minVal);
    
    % Scale and shift to [-1, 1]
    scaledNumbers = 2 * normalizedNumbers - 1;

    indv = centerOfMass + ((upper-lower)*scaledNumbers)/gen;
    indv = max(min(indv, upper), lower);
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