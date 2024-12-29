% Apply mutation operator on a pair of parents
%
% INPUT: 
% 'chrom' is the chromosome of the individual to be mutated
%
% OUTPUT: 
% 'chrom' is the mutated chromosome [t*2+1 x n+4]
function [chrom] = mutation(chrom)
    
    global op;  % optimization problem
    global eas; % genetic algorithm settings
    
    if rand() <= eas.ga.mutation_probability
        % do mutation
        switch eas.ga.mutation_method
            case 'random'
                chrom = randomMutation();
            case 'modifiedRandom'
                chrom = modifiedRandomMutation(chrom);
            case 'polynomial'
                chrom = polynomialMutation(chrom);
            otherwise
                error('Unexpected Mutation Method.');
        end
    end

end

%--------------RANDOM MUTATION--------------

function [chrom] = randomMutation()
    chrom = generateRandomChromosome();
end

%--------------POLYNOMIAL MUTATION--------------

function [chrom] = polynomialMutation(chrom)
    global op;  % optimization problem
    global eas; % genetic algorithm settings
    error('This Mutation Method is not implemented yet.');
end
