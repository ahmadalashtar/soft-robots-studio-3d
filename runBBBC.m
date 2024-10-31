function [pop, fit_array_P,fitnesses] = runBBBC(exp)
    
    global eas;       % big bang-big crunch settings

    rng shuffle


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

        fitnesses(gen,:) = fit_array_P(1,:);
    end    

end



