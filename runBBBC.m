function [best, bestFitness] = runBBBC(exp)
    
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

    %--Update Best
    bestFitness = fit_array_P(1,:);
    bestIndex = bestFitness(eas.fitIdx.id);
    best = pop(:,:,bestIndex);

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
        
        %--Update Best
        bestPopFitness = fit_array_P(fit_array_P(:,eas.fitIdx.rank)==1,:);
        bestPopIndex = bestPopFitness(eas.fitIdx.id);
        bestPop = pop(:,:,bestPopIndex);
        [best, bestFitness] = updateBest(best,bestPop,bestFitness,bestPopFitness);

        %--VERBOSE (SHOW LOG)
        if eas.verbose
            fprintf('[%d.%d]\t', exp, gen);
            if bestFitness(1,eas.fitIdx.pen) == 0
                fprintf('feas: ');
            else
                fprintf('unfs: ');
            end
            fprintf('IK %.3f ', bestFitness(1,eas.fitIdx.ik));
            fprintf('(1st P: %.3f-%.3f, #%d), ', eas.rankingSettings.minFit, eas.rankingSettings.minFit + eas.rankingSettings.step_ik, eas.rankingSettings.firstPartitionSize);
            fprintf('LtS %d, ', bestFitness(1,eas.fitIdx.nodes));
            fprintf('UND %d%%, ', round(bestFitness(1,eas.fitIdx.wiggly)));
            fprintf('LoS %d, ', bestFitness(1,eas.fitIdx.nodesOnSegment));
            fprintf('Length %.3f', bestFitness(1,eas.fitIdx.totLength));
            fprintf('\n');
        end

    end    

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