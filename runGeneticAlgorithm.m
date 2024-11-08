% Run the Genetic Algorithm
%
% INPUT: none
%
% OUTPUT: 
% 'pop' is the population at the last generation of the algorithm [t+1 x n+4 x n_individuals]
% 'fit_array', is a matrix with fitness values, composed of 'ik fitness', 'number of nodes', 'rank fitness', 'index in the pop array'[n_individuals x 4]
function [pop, fit_array_P] = runGeneticAlgorithm(exp)
    
    global eas; % genetic algorithm settings
    
    %--INITIALIZATION 
    variance_array= zeros(1,eas.n_individuals);
    queue=zeros(1,eas.variance_generations);   % queue used to calculate the variance of the last 'variance_generations' generations best individuals
    qIndex = 1;
    
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

        % calculate variance over the last 'varianceGen' generations
        
        % [~, comD] = centerOfMass(pop);
        queue(qIndex)=fit_array_P(1,eas.fitIdx.ik);     % variance is on ik fitness only (ranking fitness depends on the current population, so it makes no sense to compare the rank of individuals from different generations)
        qIndex=qIndex+1;                    % the queue is implemented as a static array
        if qIndex>size(queue,2)             % when the index reaches the end of the array
            qIndex = 1;                     % goes back to 1
        end
        variance = var(nonzeros(queue));    % calculate variance
        variance_array(gen)= variance;
        
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
            fprintf('OND %d%%, ', fit_array_P(1,eas.fitIdx.wiggly));
            fprintf('LoS %d, ', fit_array_P(1,eas.fitIdx.nodesOnSegment));
            fprintf('Length %.3f', fit_array_P(1,eas.fitIdx.totLength));
            
            % for i=1:1:size(comD,2)
            %     fprintf('%.4f', comD(i));
            %     if i~=size(comD,2)
            %         fprintf(', ');
            %     end
            % end    
            % fprintf('] = %.4f', mean(comD));
            
%             if dynamic_mutation == true
%                 fprintf(', Dynamic Mutation: %.4f', gas.mutation_probability);
%             end
            fprintf('\n');
        end
      
%         %--DRAW BEST INDIVIDUAL (DEBUG) 
%         if gas.draw_plot == true
%             best_index = fit_array_P(1,4);
%             configurations = decodeIndividual(pop(:,:,best_index));
%             drawProblem2D(configurations);
%         end
        
        %--SPECIAL CONVERGENCE CONDITIONS
        
        % stop if the variance is 0.0000
        if eas.stopAtVariance_flag == true
            if (round(variance,eas.stopAtVariance_zeros) == 0) && (gen>eas.variance_generations*2)
                break;
            end
        end
        
        % stop if we reached a fitness of 0.0000, this will likely never be true
        if eas.stopAtFitness_flag == true && round(fit_array_P(1,1), eas.stopAtFitness_zeros) == 0
            break;
        end
        
         %--DYNAMIC AGGIUSTMENTS
         if dynamic_mutation == true
            eas.ga.mutation_probability = eas.ga.mutation_probability - mp_increment; 
            if eas.ga.mutation_probability < 0
                eas.ga.mutation_probability = 0;
            end
         end
         
    end  % place a breakpoint here as you run the algorithm to pause, and check how the individuals are evolving by plotting the best one with 'drawProblem2D(decodeIndividual(pop(:,:,1)))'

    %--FOR EXPERIMENT FILEs
    for i=eas.n_individuals:-1:1
        if(round(variance_array(i),1) > 0)
            eas.convergence0 = i-eas.variance_generations;
            break;
        end
    end
    for i=eas.n_individuals:-1:1
        if(round(variance_array(i),2) > 0)
            eas.convergence00 = i-eas.variance_generations;
            break;
        end
    end
    
end
