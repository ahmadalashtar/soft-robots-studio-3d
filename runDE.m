% Run the Genetic Algorithm
%
% INPUT: none
%
% OUTPUT: 
% 'pop' is the population at the last generation of the algorithm [t+1 x n+4 x n_individuals]
% 'fit_array', is a matrix with fitness values, composed of 'ik fitness', 'number of nodes', 'rank fitness', 'index in the pop array'[n_individuals x 4]
function [pop, fit_array_P] = runDE(exp)
    
    global eas; % genetic algorithm settings
    
    %--INITIALIZATION 
    variance_array= zeros(1,eas.n_individuals);
    queue=zeros(1,eas.variance_generations);   % queue used to calculate the variance of the last 'variance_generations' generations best individuals
    qIndex = 1;
    
    % a funnier user...
    if eas.n_individuals < 6
        eas.n_individuals = 6;
    end
    
    
    
    %--RANDOM INITIALIZATION
    pop = initializeRandomPopulation();  % pop is [t*2+1 x n+4 x n_individuals]

    %--EVALUATION
    [pop, fit_array_P] = evaluate(pop);
    [fit_array_P] = rankingEvaluation(fit_array_P);
    
    %--ITERATIONS
    for gen=1:eas.n_generations
        mutants = calculateMutantVectors(pop, fit_array_P);
        
        trials = calculateTrialVectors(pop,mutants);
        [trials, fit_array_T] = evaluate(trials);
        [fit_array_T] = rankingEvaluation(fit_array_T);
        
        %--SURVIVOR
        [pop, fit_array_P] = survivor(pop, trials, fit_array_P, fit_array_T);

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

function mutants = calculateMutantVectors(pop,fitness)
    global eas;
    
    mutants = pop;
    fittestID = fitness(:, eas.fitIdx.rank) == 1;

    rows = size(pop,1);
    columns = size(pop,2);
    individuals = size(pop,3);
    

    
    for k = 1 : individuals
        indices = 1:size(pop,3);
        indices(targetIndex) = [];
        randIndices = datasample(indices, 5, 'Replace', false);
        
        r1 = pop(row,column,randIndices(1));
        r2 = pop(row,column,randIndices(2));
        r3 = pop(row,column,randIndices(3));
        r4 = pop(row,column,randIndices(4));
        r5 = pop(row,column,randIndices(5));
        for j = 1 : columns
            for i = 1 : rows
                mutants(i,j,k) = mutateVector(pop,i,j,k,fittestID,r1,r2,r3,r4,r5);
            end
        end
    end
end

function mutant = mutateVector(pop,row,column,targetIndex,fittestID,r1,r2,r3,r4,r5)
    global eas;
    best = pop(:,:,fittestID);
    xi = pop(row,column,targetIndex);
    F = eas.de.scalingFactor;
    switch eas.de.variant
        case 1
            mutant = r1+F*(r2-r3); %xr1+F(xr2−xr3)
        case 2
            mutant = best+F*(r1-r2); %xbest+F(xr1−xr2)
        case 3 
            mutant = r1+F*(r2-r3)+F*(r4-r5); %xr1+F(xr2−xr3)+F(xr4−xr5)
        case 4
            mutant = best+F*(r1-r2)+F*(r3-r4); %xbest+F(xr1−xr2)+F(xr3−xr4)
        case 5
            mutant = xi+F*(best-xi)+F*(r1-r2); %xi+F(xbest−xi)+F(xr1−xr2)
        case 6
            mutant = xi + (r1-xi)*rand() + F*(r2-r3); %xi+rand(xr1−xi)+F(xr2−xr3)
    end
    lengthsIndex = size(pop,1);
    minLength = op.length_domain(1);
    maxLength = op.length_domain(2);
    minAngle = op.angle_domain(1);
    maxAngle = op.angle_domain(2);
    if row == lengthsIndex
        % swarm(i).position(j,k) = max(min(swarm(i).position(j,k),maxLength),minLength); %Clamping (Saturation)
        mutant = mod(mutant,maxLength-minLength+1) + minLength; % Wrapping (Modulus Operator)  
    else
        % swarm(i).position(j,k) = max(min(swarm(i).position(j,k),maxAngle),minAngle) + minAngle; % Clamping (Saturation)
        mutant = mod(abs(mutant),maxAngle-minAngle+1) + minAngle; % Wrapping (Modulus Operator)  
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
    

end