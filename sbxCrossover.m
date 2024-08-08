function [child1, child2] = sbxCrossover(parent1, parent2, lower_bound, upper_bound)
global op;  % optimization problem
global eas; % genetic algorithm settings
    % Simulated Binary Crossover (SBX)
    % Inputs:
    %   parent1, parent2 - Parent solutions
    %   eta_c - Distribution index for crossover
    %   lower_bound - Lower bound of the variables
    %   upper_bound - Upper bound of the variables
    % Outputs:
    %   child1, child2 - Child solutions
    
    % Ensure parents are row vectors
    eta_c = eas.ga.eta_crossover;
    if iscolumn(parent1)
        parent1 = parent1';
    end
    if iscolumn(parent2)
        parent2 = parent2';
    end
    
    % Initialize children
    child1 = zeros(size(parent1));
    child2 = zeros(size(parent2));
    
    % Number of decision variables
    nVar = length(parent1);
    
    for i = 1:nVar
        beta  = 0;
        mu    = rand();
        if(mu <= 0.5)
            beta = (2*mu).^(1/(eta_c+1));
        else
            beta  = (2-2*mu).^(-1/(eta_c+1));
        end
        beta = beta.*(-1).^randi([0,1]);

        if(rand() < 0.5)
            beta = 1;
        end
        
        % -----------------------***----------------------- %

        child1(i) = 0.5 * (parent1(i) + parent2(i)) + beta * (parent1(i)-parent2(i)) * 0.5;
        child2(i) = 0.5 * (parent1(i) + parent2(i)) - beta * (parent1(i) - parent2(i)) * 0.5;

        %
        % xVal = 0.5 * (parent1(i) + parent2(i));
        % child1(i) = xVal - 0.5 * beta * (parent2(i) - parent1(i));
        % child2(i) = xVal + 0.5 * beta * (parent2(i) - parent1(i));
        % child1(i) = 0.5 * (parent1(i) + parent2(i) - beta*(parent2(i) - parent1(i)));
        % child2(i) = 0.5 * (parent1(i) + parent2(i) + beta*(parent2(i) - parent1(i)));
        
        % ensuring children are within bounds
        child1(i) = min(max(child1(i), lower_bound(i)), upper_bound(i));
        child2(i) = min(max(child2(i), lower_bound(i)), upper_bound(i));
    end
end