% Run the Genetic Algorithm
%
% INPUT: none
%
% OUTPUT: 
% 'pop' is the population at the last generation of the algorithm [t+1 x n+4 x n_individuals]
% 'fit_array', is a matrix with fitness values, composed of 'ik fitness', 'number of nodes', 'rank fitness', 'index in the pop array'[n_individuals x 4]
function [pop, fit_array_P] = runGeneticAlgorithm(exp)
    
    global eas; % genetic algorithm settings
   
    
    % a funnier user...
    if eas.n_individuals <= 0
        eas.n_individuals = 2;
    end

    % in case a funny user decides to have an odd number of idividuals in the population...
    if mod(eas.n_individuals,2) ~= 0
        eas.n_individuals = eas.n_individuals + 1;
    end
    
    
    
    %---------------DYNAMIC MUTATION---------------
    dynamic_mutation = false;
    if eas.ga.mutation_probability == -1.0
        mp_increment = 1.0 /eas.n_generations;    
        eas.ga.mutation_probability = 1.0;
        dynamic_mutation = true;
    end
    
    %--RANDOM INITIALIZATION
    pop = initializeRandomPopulation();  % pop is [t+1 x n+4 x n_individuals]

    %--EVALUATION
    [pop, fit_array_P] = evaluate(pop);
    [fit_array_P] = rankingEvaluation(fit_array_P);
    
    %--ITERATIONS
    for gen=1:1:eas.n_generations
        %--SELECTION
        matPool = selection(fit_array_P(:,[eas.fitIdx.rank, eas.fitIdx.id]));   % passing to selection only rank fitness and pop-related id
        
        %--VARIATION
        offspring = variation(pop, matPool);
        
        %--EVALUATION
        [offspring, fit_array_O] = evaluate(offspring);
        [fit_array_O] = rankingEvaluation(fit_array_O);
         
        %--SURVIVOR
        [pop, fit_array_P] = survivor(pop, offspring, fit_array_P, fit_array_O);
        
        
        %--VERBOSE (SHOW LOG)
        if eas.verbose
            fprintf('[%d.%d]\t', exp, gen);
            if fit_array_P(1,eas.fitIdx.pen) == 0
                fprintf('Feasible Solution: ');
            else
                fprintf('Unfeasible Solution: ');
            end
            fprintf('IK %.3f ', fit_array_P(1,eas.fitIdx.ik));
            fprintf('(1st P: %.3f-%.3f, #%d), ', eas.rankingSettings.minFit, eas.rankingSettings.minFit + eas.rankingSettings.step_ik, eas.rankingSettings.firstPartitionSize);
            fprintf('LtS %d, ', fit_array_P(1,eas.fitIdx.nodes));
            fprintf('UND %d%%, ', round(fit_array_P(1,eas.fitIdx.wiggly)));
            fprintf('LoS %d, ', fit_array_P(1,eas.fitIdx.nodesOnSegment));
            fprintf('Length %.3f', fit_array_P(1,eas.fitIdx.totLength));
            fprintf('\n');
        end
      
                
         %--DYNAMIC AGGIUSTMENTS
         if dynamic_mutation == true
            eas.ga.mutation_probability = eas.ga.mutation_probability - mp_increment; 
            if eas.ga.mutation_probability < 0
                eas.ga.mutation_probability = 0;
            end
         end
         
    end  % place a breakpoint here as you run the algorithm to pause, and check how the individuals are evolving by plotting the best one with 'drawProblem2D(decodeIndividual(pop(:,:,1)))'
    
end
