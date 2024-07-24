% Apply crossover operator on a pair of parents
%
% INPUT: 
% 'p1' is the chromosome of the first parent [t+1 x n+4]
% 'p2' is the chromosome of the second parent [t+1 x n+4]
%
% OUTPUT: 
% 'o1' is the chromosome of the first child [t+1 x n+4]
% 'o2' is the chromosome of the second child [t+1 x n+4]
function [o1, o2] = crossover(p1, p2)
    
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    
    if rand() <= gas.crossover_probability
        % do crossover
        switch gas.crossover_method
            case 'blxa'
                alpha = 0.5;
                if(gas.obstacle_avoidance==true)
                    o1 = blendCrossover_obstacleAvoidance(p1, p2, alpha);
                    o2 = blendCrossover_obstacleAvoidance(p1, p2, alpha);
                else
                    o1 = blendCrossover(p1, p2, alpha);
                    o2 = blendCrossover(p1, p2, alpha);
                end

            case 'sbx'
                eta = 5;
                o1 = sbxCrossover(p1, p2, eta);
                o2 = sbxCrossover(p1, p2, eta);
            otherwise
                error('Unexpected Crossover Method.');
        end
    else
        % don't do crossover, copy from parents
        o1 = p1;
        o2 = p2;
        % make sure the extra genes of the chromosome are not copied from the parent, otherwise this chromosome will be corrupted during evaluation
        o1(:,op.n_nodes+1:op.n_nodes+gas.extra_genes) = 0;  
        o2(:,op.n_nodes+1:op.n_nodes+gas.extra_genes) = 0;
    end

end