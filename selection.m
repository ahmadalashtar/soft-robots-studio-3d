% Select individuals for reproduction
%
% INPUT: 
% 'fit_array' is [n_individuals x 2] containing the fitness of each individual in the population and the index of the individual in the array 'pop'
%
% OUTPUT: 
% 'matPool' is [n_individuals x 1] containing the indices of the individual selected for reproduction
%
% IMPORTANT ---> the indices in the mating pool refer to the individuals in the array 'pop'
function [matPool] = selection(fit_array)

    global eas; % genetic algorithm settings
    
    switch eas.ga.selection_method
        case 'tournament'
            matPool = tournament(fit_array, 2, true);	% binary tournament selection
        case 'proportionate'
            matPool = proportionate(fit_array, true);	% fitness proportioante selection over rank
        otherwise
            error('Unexpected Selection Method.');
    end
end