%starts the GA algorithm
%input is a number, defaults to 1
%output is the best individual with its best fitness

function [best, bestFitness] = runGeneticAlgorithm(exp)
    
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
pop = initializeRandomPopulation();  % pop is [t*2+1 x n+4 x n_individuals]

    %--EVALUATION
    [pop, fit_array_P] = evaluate(pop);
    [fit_array_P] = rankingEvaluation(fit_array_P);
    
    %--Update Best
    bestFitness = fit_array_P(1,:);
    bestIndex = bestFitness(eas.fitIdx.id);
    best = pop(:,:,bestIndex);

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
        if (eas.penalty_method == "adaptive")
            fit_array_P(:,eas.fitIdx.ik) = fit_array_P(:,eas.fitIdx.ik) - fit_array_P(:,eas.fitIdx.pen);
            fit_array_P = checkConstraints(pop, fit_array_P);
            [pop, fit_array_P] = survivor(pop, offspring, fit_array_P, fit_array_O);
            adaptivePenCalculation(fit_array_P(1,:));
        else
            [pop, fit_array_P] = survivor(pop, offspring, fit_array_P, fit_array_O);
        end
        
        
        %--Update Best
        bestPopFitness = fit_array_P(1,:);
        bestPopIndex = bestPopFitness(eas.fitIdx.id);
        bestPop = pop(:,:,bestPopIndex);

        [best, bestFitness] = updateBest(best,bestPop,bestFitness,bestPopFitness);
        


        %--VERBOSE (SHOW LOG)
        if eas.verbose
            fprintf('[%d.%d]\t', exp, gen);
            if bestFitness(1,eas.fitIdx.pen) == 0
                fprintf('Feasible Solution: ');
            else
                fprintf('Unfeasible Solution: ');
            end
            fprintf('IK %.3f ', bestFitness(1,eas.fitIdx.ik));
            fprintf('(1st P: %.3f-%.3f, #%d), ', eas.rankingSettings.minFit, eas.rankingSettings.minFit + eas.rankingSettings.step_ik, eas.rankingSettings.firstPartitionSize);
            fprintf('LtS %d, ', bestFitness(1,eas.fitIdx.nodes));
            fprintf('UND %d%%, ', round(bestFitness(1,eas.fitIdx.wiggly)));
            fprintf('LoS %d, ', bestFitness(1,eas.fitIdx.nodesOnSegment));
            fprintf('Length %.3f', bestFitness(1,eas.fitIdx.totLength));
            fprintf('\n');
        end
            
                
         %--DYNAMIC AGGIUSTMENTS
         if dynamic_mutation == true
            eas.ga.mutation_probability = eas.ga.mutation_probability - mp_increment; 
            if eas.ga.mutation_probability < 0
                eas.ga.mutation_probability = 0;
            end
         end
         
    end  % place a breakpoint here as you run the algorithm to pause, and check how the individuals are evolving by plotting the best one with 'drawProblem3D(decodeIndividual(pop(:,:,1)))'
    
end

function [best, bestFitness] = updateBest(best,best2,bestFitness,best2Fitness)
global eas;
if eas.survival_method == "non-elitist"
    bestFitness(eas.fitIdx.id) = 1;
    best2Fitness(eas.fitIdx.id) = 2;
    TwoBestsFitness = [bestFitness;best2Fitness];
    [TwoBestsFitness] = rankingEvaluation(TwoBestsFitness);
    bestFitness =  TwoBestsFitness(1,:);
    if bestFitness(eas.fitIdx.id) == 2
        best = best2;
    end
else
    best = best2;
    bestFitness = best2Fitness;
end
end