function [localBests, localBestsFitness] = runPSO(exp)
    
    global eas;
    global op;
    rng shuffle

    %--INITIALIZATION 
    variance_array= zeros(1,eas.n_individuals);
    queue=zeros(1,eas.variance_generations);   % queue used to calculate the variance of the last 'variance_generations' generations best individuals
    qIndex = 1;

    % in case a funny user decides to have a negative number or zero for individuals in the population...
    if eas.n_individuals <= 0
        eas.n_individuals = 1;
    end
    
    global eas;


    n_targets = size(op.targets,1);
    n_links = op.n_links;
    extra_genes = eas.extra_genes;
    n_individuals = eas.n_individuals;

    swarm(n_individuals) = ...
        struct('position', [], 'fitness', [], 'velocity', [], 'localBest', [], 'localBestFitness',[]);

    swarm = initializeSwarm(swarm);
    
    for gen=1:1:eas.n_generations

        oldSwarm = swarm;
        swarm = updateSwarm(swarm);
        swarm = applySurvival(swarm,oldSwarm);
        fittest = eas.pso.globalBest;
        bestFitness = fittest.fitness;
        % calculate variance over the last 'varianceGen' generations
        
        queue(qIndex)=bestFitness(eas.fitIdx.ik);     % variance is on ik fitness only (ranking fitness depends on the current population, so it makes no sense to compare the rank of individuals from different generations)
        qIndex=qIndex+1;                    % the queue is implemented as a static array
        if qIndex>size(queue,2)             % when the index reaches the end of the array
            qIndex = 1;                     % goes back to 1
        end
        variance = var(nonzeros(queue));    % calculate variance
        variance_array(gen)= variance;
        

        %--VERBOSE (SHOW LOG)
        if eas.verbose
            fprintf('[%d.%d]\t', exp, gen);
            if bestFitness(eas.fitIdx.pen) == 0
                fprintf('feas: ');
            else
                fprintf('unfs: ');
            end
            fprintf('IK %.3f ', bestFitness(eas.fitIdx.ik));
            fprintf('(1st P: %.3f-%.3f, #%d), ', eas.rankingSettings.minFit, eas.rankingSettings.minFit + eas.rankingSettings.step_ik, eas.rankingSettings.firstPartitionSize);
            fprintf('LtS %d, ', bestFitness(eas.fitIdx.nodes));
            fprintf('OND %d%%, ', bestFitness(eas.fitIdx.wiggly));
            fprintf('LoS %d, ', bestFitness(eas.fitIdx.nodesOnSegment));
            fprintf('Length %.3f', bestFitness(eas.fitIdx.totLength));
            
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
        if eas.stopAtFitness_flag == true && round(bestFitness(1), eas.stopAtFitness_zeros) == 0
            break;
        end

    end    
    localBests = localBestToArray(swarm);
    localBestsFitness = localBestsFitnessToArray(swarm);
    [localBests , localBestsFitness] = evaluate(localBests);
    [localBestsFitness] = rankingEvaluation(localBestsFitness);
    % fitness = fitnessToArray(swarm);
    % positions = positionsToArray(swarm);
end
function localBests = localBestToArray(swarm)
    rows = size(swarm(1).position,1);
    columns = size(swarm(1).position,2);
    matrices = size(swarm,2);

    localBests = zeros(rows,columns,matrices);
    
    for i = 1 : size(swarm,2)
        localBests(:,:,i) = swarm(i).localBest;
    end 
end
function localBestsFitness = localBestsFitnessToArray(swarm)
    rows = size(swarm,2);
    columns = size(swarm(1).localBestFitness,2);

    localBestsFitness = zeros(rows,columns);
    for i = 1 : size(swarm,2)
        localBestsFitness(i,:) = swarm(i).localBestFitness;
    end
end
function fitness = fitnessToArray(swarm)
    rows = size(swarm,2);
    columns = size(swarm(1).fitness,2);

    fitness = zeros(rows,columns);
    for i = 1 : size(swarm,2)
        fitness(i,:) = swarm(i).fitness;
    end
end

function positions = positionsToArray(swarm)
    rows = size(swarm(1).position,1);
    columns = size(swarm(1).position,2);
    matrices = size(swarm,2);

    positions = zeros(rows,columns,matrices);
    
    for i = 1 : size(swarm,2)
        positions(:,:,i) = swarm(i).position;
    end  
end

function swarm = applySurvival(swarm, oldSwarm)
    global eas;
    oldSwarmPositions = positionsToArray(oldSwarm);
    swarmPositions = positionsToArray(swarm);
    oldSwarmFitness = fitnessToArray(oldSwarm);
    swarmFitness = fitnessToArray(swarm);


    [positions, fitness] = ...
        survivor(oldSwarmPositions, swarmPositions, oldSwarmFitness, swarmFitness);

    for i = 1 : size(positions,3)
        swarm(i).position = positions(:,:,i);
    end

    for i = 1 : size(swarm,2)
        index = fitness(i,eas.fitIdx.id);
        swarm(index).fitness = fitness(i,:);
    end

end


function swarm = initializeSwarm(swarm)
    global eas;
    swarm = initializePositions(swarm);
    swarm = calculateFitness(swarm);
    swarm = initializeLocalBest(swarm);
    eas.pso.globalBest = getFittest(swarm);
    swarm = initializeVelocity(swarm);
end

function swarm=updateSwarm(swarm)
    global eas;
    swarm = updateVelocity(swarm);
    swarm = updatePosition(swarm);
    swarm = calculateFitness(swarm);
    eas.pso.globalBest = updateGlobalBest(swarm);
    swarm = updateLocalBest(swarm);
end

function swarm = updateLocalBest(swarm)
    for i = 1 : size(swarm,2)
        particle.position = swarm(i).position;
        particle.fitness = swarm(i).fitness;
        localBest.position = swarm(i).localBest;
        localBest.fitness = swarm(i).localBestFitness;
        best = bestOfTwo(particle,localBest);
        swarm(i).localBest = best.position;
        swarm(i).localBestFitness = best.fitness;
    end
end

function best = bestOfTwo(first,second)
    global eas;
    first.fitness(eas.fitIdx.id) = 1;
    second.fitness(eas.fitIdx.id) = 2;
    rows = size(first.position,1);
    columns = size(first.position,2);
    matrices = 2;
    positions = zeros(rows,columns,matrices);
    positions(:,:,1) = first.position;
    positions(:,:,2) = second.position;
    fitness = [first.fitness;second.fitness];
    fitness = rankingEvaluation(fitness);
    fittestIndex = fitness(:, eas.fitIdx.rank) == 1;
    best.fitness = fitness(fittestIndex,:);
    best.position = positions(:,:,best.fitness(eas.fitIdx.id));
end

function globalBest = updateGlobalBest(swarm)
    global eas;
    localFittest = getFittest(swarm);
    currentGBest = eas.pso.globalBest;
    globalBest= bestOfTwo(currentGBest,localFittest);
    
end

function swarm = updatePosition(swarm)
    global op;

    minLength = op.length_domain(1);
    maxLength = op.length_domain(2);
    minAngle = op.angle_domain(1);
    maxAngle = op.angle_domain(2);

    lengthsIndex = size(swarm(1).position,1);

    for i = 1 : size(swarm,2)
        for j = 1 : size(swarm(1).position,1)
            for k = 1 : size(swarm(1).position,2)
                swarm(i).position(j,k) = swarm(i).position(j,k) + swarm(i).velocity(j,k); 
                % swarm(i).position(j,k) = swarm(i).position(j,k) + swarm(i).velocity(j,k)/abs(swarm(i).velocity(j,k)); 
                if j == lengthsIndex
                    % swarm(i).position(j,k) = max(min(swarm(i).position(j,k),maxLength),minLength); %Clamping (Saturation)
                    swarm(i).position(j,k) = mod(swarm(i).position(j,k),maxLength-minLength+1) + minLength; % Wrapping (Modulus Operator)  
                else
                    % swarm(i).position(j,k) = max(min(swarm(i).position(j,k),maxAngle),minAngle) + minAngle; % Clamping (Saturation)
                    swarm(i).position(j,k) = mod(abs(swarm(i).position(j,k)),maxAngle-minAngle+1) + minAngle; % Wrapping (Modulus Operator)  
                end
                
            end
        end
    end
end

function swarm = initializePositions(swarm)
    positions = initializeRandomPopulation();
    for i = 1 : size(positions,3)
        swarm(i).position = positions(:,:,i);
    end
end


function swarm = calculateFitness(swarm)
    global eas;

    positions = positionsToArray(swarm);
    
    [positions , fitness] = evaluate(positions);

    for i = 1 : size(swarm,2)
        swarm(i).position = positions(:,:,i);
    end

    [fitness] = rankingEvaluation(fitness);
    
    for i = 1 : size(swarm,2)
        index = fitness(i,eas.fitIdx.id);
        swarm(index).fitness = fitness(i,:);
    end

        
end

function fittest = getFittest(swarm)
    global eas;
    for i = 1 : size(swarm,2)
        if swarm(i).fitness(eas.fitIdx.rank) == 1
            fittest.position = swarm(i).position;
            fittest.fitness = swarm(i).fitness;
            break;
        end
    end
end

function swarm = initializeLocalBest(swarm)
    for i = 1 : size(swarm,2)
        swarm(i).localBest = swarm(i).position;
        swarm(i).localBestFitness = swarm(i).fitness;
    end
end

function swarm = initializeVelocity(swarm)
    rows = size(swarm(1).position,1);
    columns = size(swarm(1).position,2);
    for i = 1 : size(swarm,2)
        swarm(i).velocity = zeros(rows,columns);
    end
end

function swarm = updateVelocity(swarm)
    global eas;
    
    w = eas.pso.omega;
    c1 = eas.pso.cognitiveConstant;
    c2 = eas.pso.socialConstant;
    gBest = eas.pso.globalBest.position;

    for i = 1 : size(swarm,2)
        for j = 1 : size(swarm(1).position,1)
            for k = 1 : size(swarm(1).position,2)
                swarm(i).velocity(j,k) = ...
                    w*swarm(i).velocity(j,k) + ...
                    rand*c1*(swarm(i).localBest(j,k)-swarm(i).position(j,k)) + ...
                    rand*c2*(gBest(j,k)-swarm(i).position(j,k));
            end
        end
    end
end

