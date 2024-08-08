% Initialize a random population of individuals
%
% INPUT: 
% 'n_individuals' is the number of individuals in the population
%
% OUTPUT: 

% 'pop' is the random population [t*2+1 x n+4 x n_individuals]

function [pop] = initializeRandomPopulation()
    global op;  % optimization problem
    global eas; % genetic algorithm settings
    global algorithm;

    switch algorithm
        case 'ga'
            % declare a static array of chromosomes filled with zeros

            pop = zeros(size(op.targets,1)*2+1,op.n_nodes+eas.extra_genes,eas.n_individuals);

            for i=1:1:eas.n_individuals
                chrom = generateRandomChromosome();   
                pop(:,:,i) = chrom;
            end
        case 'bbbc'
            % declare a static array of individuals filled with zeros

            pop = zeros(size(op.targets,1)*2+1,op.n_nodes+eas.extra_genes,eas.n_individuals);

            for i=1:1:eas.n_individuals
                indv = generateRandomChromosome();   
                pop(:,:,i) = indv;
            end
            
    end        
end
    


    

% A single chromosome is a matrix [t x 2 + 1 x n+4]:

%  |                 |         |         |         |         |
%  |   (t * 2x n)    | (t x 2) | (t x 2) | (t x 2) | (t x 2) |
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
%        robot            extra genes of the
%    configurations           chromosome
%
% extra genes:
% - index of node on the target's orientation segment
% - angle to align to the orientation segment
% - index of last joint (the node before the end effector)
% - last link length