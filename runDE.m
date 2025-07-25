%starts the DE algorithm
%input is a number, defaults to 1
%output is the best individual with its best fitness

function [best, bestFitness] = runDE(exp)
    
    global eas; % genetic algorithm settings
        
    % a funnier user...
    if eas.n_individuals < 6
        eas.n_individuals = 6;
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
    for gen=1:eas.n_generations
        mutants = calculateMutantVectors(pop, fit_array_P);
        
        trials = calculateTrialVectors(pop,mutants);
        [trials, fit_array_T] = evaluate(trials);
        [fit_array_T] = rankingEvaluation(fit_array_T);
        
        %--SURVIVOR
        if(eas.penalty_method == "adaptive")
            fit_array_P(:,eas.fitIdx.ik) = fit_array_P(:,eas.fitIdx.ik) - fit_array_P(:,eas.fitIdx.pen);
            fit_array_P = checkConstraints(pop, fit_array_P);
            [pop, fit_array_P] = survivor(pop, trials, fit_array_P, fit_array_T);
            adaptivePenCalculation(fit_array_P(1,:));    
        else
            [pop, fit_array_P] = survivor(pop, trials, fit_array_P, fit_array_T);
        end

        %--Update Best
        bestPopFitness = fit_array_P(fit_array_P(:,eas.fitIdx.rank)==1,:);
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
        
         
    end  % place a breakpoint here as you run the algorithm to pause, and check how the individuals are evolving by plotting the best one with 'drawProblem2D(decodeIndividual(pop(:,:,1)))'
    
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

function mutants = calculateMutantVectors(pop,fitness)
global eas;

mutants = pop;
fittestFitnessIndex = fitness(:, eas.fitIdx.rank) == 1;
fittestPopIndex = fitness(fittestFitnessIndex,eas.fitIdx.id);

rows = size(pop,1);
columns = size(pop,2);
individuals = size(pop,3);



for k = 1 : individuals
    indices = 1:size(pop,3);
    indices(k) = [];
    randIndices = datasample(indices, 5, 'Replace', false);

    r1 = randIndices(1);
    r2 = randIndices(2);
    r3 = randIndices(3);
    r4 = randIndices(4);
    r5 = randIndices(5);
    for j = 1 : columns
        for i = 1 : rows
            mutants(i,j,k) = mutateVector(pop,i,j,k,fittestPopIndex,pop(i,j,r1),pop(i,j,r2),pop(i,j,r3),pop(i,j,r4),pop(i,j,r5));
        end
    end
    
end
mutants(1:end-1,1,:) = 0;
end

function mutant = mutateVector(pop,row,column,targetIndex,fittestPopIndex,xr1,xr2,xr3,xr4,xr5)
global eas;
global op;
best = pop(:,:,fittestPopIndex);
xi = pop(row,column,targetIndex);
F = eas.de.scalingFactor;
switch eas.de.variant
    case 1
        mutant = xr1+F*(xr2-xr3); %xr1+F(xr2−xr3)
    case 2
        mutant = best(row,column)+F*(xr1-xr2); %xbest+F(xr1−xr2)
    case 3
        mutant = xr1+F*(xr2-xr3)+F*(xr4-xr5); %xr1+F(xr2−xr3)+F(xr4−xr5)
    case 4
        mutant = best(row,column)+F*(xr1-xr2)+F*(xr3-xr4); %xbest+F(xr1−xr2)+F(xr3−xr4)
    case 5
        mutant = xi+F*(best(row,column)-xi)+F*(xr1-xr2); %xi+F(xbest−xi)+F(xr1−xr2)
    case 6
        mutant = xi + (xr1-xi)*rand() + F*(xr2-xr3); %xi+rand(xr1−xi)+F(xr2−xr3)
end
lengthsIndex = size(pop,1);
minLength = op.length_domain(1);
maxLength = op.length_domain(2);
minAngle = op.angle_domain(1);
maxAngle = op.angle_domain(2);
if row == lengthsIndex
    % swarm(i).position(j,k) = max(min(swarm(i).position(j,k),maxLength),minLength); %Clamping (Saturation)
    % mutant = mod(mutant,maxLength-minLength+1) + minLength; % Wrapping (Modulus Operator)
    mutant = max(min(mutant,maxLength),minLength);
else
    % swarm(i).position(j,k) = max(min(swarm(i).position(j,k),maxAngle),minAngle) + minAngle; % Clamping (Saturation)
    % mutant = mod(abs(mutant),maxAngle-minAngle+1) + minAngle; % Wrapping (Modulus Operator)
    mutant = max(min(mutant,maxAngle),minAngle);
end

end

function trials = calculateTrialVectors(pop,mutants)
global eas;

trials = pop;
rows = size(pop,1);
columns = size(pop,2);
individuals = size(pop,3);



for k = 1 : individuals
    for j = 1 : columns
        for i = 1 : rows
            if rand() <= eas.de.crossoverProbability
                trials(i,j,k) = mutants(i,j,k);
            end
        end
    end
end
trials(1:end-1,1,:) = 0;

end