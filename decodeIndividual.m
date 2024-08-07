% Transform a chromosome into a robot configurations expressed as pairs <angle1, angle2, link length>
%
% INPUT: 
% 'robot_chromosome' is the chromosome representing one individual of the population [t*2+1 x n+5]
%
% OUTPUT: 
% 'robot_configurations' is [n x 3 x t] containing pairs <angle, link length> for each node for each configuration (each target)
function [robot_configurations] = decodeIndividual(robot_chromosome)
    
    global eas;
    n_targets = floor(size(robot_chromosome,1)/2);
    n_nodes = size(robot_chromosome,2) - gas.extra_genes;
    

    l = size(robot_chromosome,1); % index of the link lengths in the chromosome

    robot_configurations = zeros(n_nodes,3,n_targets);
    
    for i=1:2:n_targets*2
        %%EMİR: I reduced n_nodes + 1 's by -1 so they all are one less
        align_index = robot_chromosome(i,n_nodes+1);    % index of the node closest to the targets orientation segment
        align_angle_x = robot_chromosome(i,n_nodes+2);    %
        align_angle_y = robot_chromosome(i+1,n_nodes+2);    %  
        last_index = robot_chromosome(i,n_nodes+3);     % index of the node before the end effector
        last_length = robot_chromosome(i,n_nodes+4);    % 
        
        robot_configuration = zeros(n_nodes,3);
        for j=1:1:n_nodes        
            
            if (align_index ~= 0 && j<align_index) || (align_index == 0)
                % use angle and length from original chromosome
                robot_configuration(j,1) = robot_chromosome(i,j);  %angle around x
                robot_configuration(j,2) = robot_chromosome(i+1,j);  %angle around y
                robot_configuration(j,3) = robot_chromosome(l,j);  %length
            elseif align_index ~= 0 && j==align_index
                % replace last angle
                robot_configuration(j,1) = align_angle_x;  %angle
                robot_configuration(j,2) = align_angle_y;  %angle
                if align_index ~= last_index
                    % use original link length    
                    robot_configuration(j,3) = robot_chromosome(l,j);  %length
                else
                    % replace link length    
                    robot_configuration(j,3) = last_length;  %length
                end
            else
                
                if (last_index ~= 0 && j<last_index) || (last_index == 0)
                    % no bending, use length from original chromosome
                    robot_configuration(j,1) = 0;  %angle x
                    robot_configuration(j,2) = 0;  %angle y
                    robot_configuration(j,3) = robot_chromosome(l,j);  %length
                elseif last_index ~= 0 && j==last_index
                    % no bending, replace last length
                    robot_configuration(j,1) = 0;  %angle x
                    robot_configuration(j,2) = 0;  %angle y
                    robot_configuration(j,3) = last_length;  %length
                else
                    % these are not used, cut them all
                    robot_configuration(j,1) = 0;  %angle x
                    robot_configuration(j,2) = 0;  %angle y
                    robot_configuration(j,3) = 0;  %length
                end
                
            end

        end
        
        robot_configurations(:,:,   ceil(i/2)) = robot_configuration;

    end
end