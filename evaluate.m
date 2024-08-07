% Evaluate fitness for a population of individuals
%
% INPUT: 
% 'pop' is the population to be evaluated [t*2+1 x n+4 x n_individuals]
%
% OUTPUT: 
% 'fit_array', is a matrix with fitness values, composed of 'ik fitness', 'number of nodes', 'rank fitness', 'index in the pop array'[n_individuals x 4]
function [pop, fit_array] = evaluate(pop)
    global op;  % optimization problem
    global eas; % genetic algorithm settings
    global bbbcs;
    global algorithm;

    switch algorithm
        case 'ga'
            fit_array = zeros(gas.n_individuals,length(fieldnames(gas.fitIdx)));

            for i=1:gas.n_individuals 
                [pop(:,:,i), fitness] = calculateFitness3D(pop(:,:,i), false);
                
                % place the right data in fit_array
                fit_array(i,gas.fitIdx.ik) = round(fitness(1),3);    % ik
                fit_array(i,gas.fitIdx.nodes) = fitness(2); % nodes
                fit_array(i,gas.fitIdx.wiggly) = fitness(3); % ondulation
                fit_array(i,gas.fitIdx.nodesOnSegment) = fitness(4); % nodes on the segments
                fit_array(i,gas.fitIdx.totLength) = fitness(5); % average length of robot
        
                % add a reference to the chromosome in the population linked to that fitness
                % it will be useful when we sort 'fit_array', because 'pop' will not be sorted
                fit_array(i,gas.fitIdx.id) = i;
            end
            
            fit_array = checkConstraints(pop, fit_array);

        case 'bbbc'
            fit_array = zeros(bbbcs.N,length(fieldnames(bbbcs.fitIdx)));

            for i=1:bbbcs.N 
                [pop(:,:,i), fitness] = calculateFitness2D(pop(:,:,i), false);
                
                % place the right data in fit_array
                fit_array(i,bbbcs.fitIdx.ik) = round(fitness(1),3);    % ik
                fit_array(i,bbbcs.fitIdx.nodes) = fitness(2); % nodes
                fit_array(i,bbbcs.fitIdx.wiggly) = fitness(3); % ondulation
                fit_array(i,bbbcs.fitIdx.nodesOnSegment) = fitness(4); % nodes on the segments
                fit_array(i,bbbcs.fitIdx.totLength) = fitness(5); % average length of robot
        
                % add a reference to the chromosome in the population linked to that fitness
                % it will be useful when we sort 'fit_array', because 'pop' will not be sorted
                fit_array(i,bbbcs.fitIdx.id) = i;
            end
    
            fit_array = checkConstraints(pop, fit_array);
            
    end  
    

end

%% DEPRECIATED -- fit_array now composed of 10 elements -- sorted by sixth column
% 'fit_array' is composed as follows, for each individual in the
% population:  
%
% -> first element is the fitness from the inverse kinematics (ik fitness), calculated as the normalized sum of the distances of each node from the target's orientation segment, overall sum for each configuration
% -> second element is the penalty value based on constraints: feasible solutions will have this value equal to 0
% -> third element is the ik fitness + penalty after the constraint evaluation where unfeasible solutions are penalized
% -> fourth element is the sum of all nodes used to reach the target orientation segment, overall sum for each configuration normalized over number of targets
% -> fifth element is the rank based on the partitions to minimize the number of nodes (rank fitness) 
% -> sixth element is the index of the individual with respect of the array 'pop', as this matrix is sorted by the third column and the order will not be the same as the individuals in the population