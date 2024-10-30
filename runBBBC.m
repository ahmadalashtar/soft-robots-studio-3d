function [pop, fit_array_P,fitnesses] = runBBBC(exp)
    
    global eas;       % big bang-big crunch settings

    rng shuffle

    %--INITIALIZATION 
    variance_array= zeros(1,eas.n_individuals);
    queue=zeros(1,eas.variance_generations);   % queue used to calculate the variance of the last 'variance_generations' generations best individuals
    qIndex = 1;
    variance = 0;

    % in case a funny user decides to have a negative number or zero for individuals in the population...
    if eas.n_individuals <= 0
        eas.n_individuals = 1;
    end
    
    pop = initializeRandomPopulation();  % pop is [t*2+1 x n+extra_genes x n_individuals]
    %--EVALUATION
    [pop, fit_array_P] = evaluate(pop);
    [fit_array_P] = rankingEvaluation(fit_array_P);
    fitnesses = fit_array_P;
    %--ITERATIONS

    for gen = 1 : eas.n_generations

        %--BIG CRUNCH
        cMass = bigCrunchPhase(pop,fit_array_P);
        
        offspring = bigBangPhase(cMass, gen);  
        
        %--EVALUATION
        [offspring, fit_array_O] = evaluate(offspring);
        [fit_array_O] = rankingEvaluation(fit_array_O);
         
        %--SURVIVOR
        [pop, fit_array_P] = survivor(pop, offspring, fit_array_P, fit_array_O);

        % calculate variance over the last 'varianceGen' generations
        
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
                fprintf('feas: ');
            else
                fprintf('unfs: ');
            end
            fprintf('IK %.3f ', fit_array_P(1,eas.fitIdx.ik));
            fprintf('(1st P: %.3f-%.3f, #%d), ', eas.rankingSettings.minFit, eas.rankingSettings.minFit + eas.rankingSettings.step_ik, eas.rankingSettings.firstPartitionSize);
            fprintf('LtS %d, ', fit_array_P(1,eas.fitIdx.nodes));
            fprintf('OND %d%%, ', fit_array_P(1,eas.fitIdx.wiggly));
            fprintf('LoS %d, ', fit_array_P(1,eas.fitIdx.nodesOnSegment));
            fprintf('Length %.3f', fit_array_P(1,eas.fitIdx.totLength));
            
            fprintf('\n');
        end

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
        fitnesses(gen,:) = fit_array_P(1,:);
    end    

end



