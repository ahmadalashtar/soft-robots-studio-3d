% Apply mutation operator on a pair of parents
%
% INPUT: 
% 'chrom' is the chromosome of the individual to be mutated
%
% OUTPUT: 
% 'chrom' is the mutated chromosome [t*2+1 x n+5]
function [chrom] = mutation(chrom)
    
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    
    if rand() <= gas.mutation_probability
        % do mutation
        switch gas.mutation_method
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
    global gas; % genetic algorithm settings
    error('This Mutation Method is not implemented yet.');
end
