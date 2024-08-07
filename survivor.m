% Perform genetic operations (crossover and mutation) on the individuals in the mating pool
%
% INPUT: 
% 'pop' is the population to be evaluated [t+1 x n+4 x n_individuals]
% 'offspring' is the population of offspring generated by genetic operations [t+1 x n+4 x n_individuals]
% 'fit_array_P' is [n_individuals x 4] containing the fitness of each individual in the population and the index of the individual in the array 'pop'
% 'fit_array_O' is [n_individuals x 4] containing the fitness of each individual in the population and the index of the individual in the array 'offspring'
%
% OUTPUT: 
% 'nextGenPop' is the population of the next generation [t+1 x n+4 x n_individuals]
% 'fit_array_NGP' is [n_individuals x 4] containing the fitness of each individual in the next generation population and the index of the individual in the array 'nextGenPop'
function [nextGenPop, fit_array_NGP] = survivor(pop, offspring, fit_array_P, fit_array_O)
    
    global op;  % optimization problem
    global eas; % genetic algorithm settings
    
    switch gas.survival_method
        case 'non-elitist'
            nextGenPop = pop;
            fit_array_NGP = fit_array_O;    % not much more to do here...
        case 'elitist_full'
            [nextGenPop, fit_array_NGP] = elitistSurvivalFull(pop, offspring, fit_array_P, fit_array_O);
        case 'elitist_alpha'
            [nextGenPop, fit_array_NGP] = elitistSurvivalAlpha(pop, offspring, fit_array_P, fit_array_O);
        otherwise
            error('Unexpected Survival Method.');
    end
    
end