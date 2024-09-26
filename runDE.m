function [bestfitness, bestsol] = runDE(exp)

global eas;
global op;
rng shuffle;

bestfitness = NaN;
bestsol = NaN;

%% Problem settings
lb = [-100 -100 -100 -100 -100];   % Lower bound
ub = [100 100 100 100 100];   % Upper bound
prob = @sphere;       % Fitness function
objectives = 1;     % Objective count

%% Parameters for Differential Evolution

% in case a funny user decides to have a negative number or zero for individuals in the population...

eas.n_individuals = 100;
eas.n_generations = 100;
eas.crossoverprobability = 0.8;

if eas.n_individuals <= 0
    eas.n_individuals = 1;
end

Np = eas.n_individuals; % = 100;   % Population size
T = eas.n_generations; %T = 100;    % Number of iterations
Pc = eas.crossoverprobability;   % Crossover probability
F = 0.85;   % Scaling factor




%% Starting of Differential Evolution
f = NaN(Np, objectives);    % Fitness value of the population
fu = NaN(Np, objectives);   % Fitness value of the new population
D = length(lb);             % Number of decision variables
U = NaN(Np, D);             % Trial solutions
P = initializeRandomPopulation(); % Initial population

[P, f] = calculateFitness(P);


if objectives ~= 1
    hold on
end

%% Iteration loop
for t = 1:T
    for i = 1:Np
        %% Mutation
        Candidates = [1:i-1 i+1:Np];    % Ensuring that current member is not partner
        idx = Candidates(randperm(Np - 1, 3)); % Selection of three random partners
        X1 = P(:,:,idx(1));              % Randomly selected solution 1
        X2 = P(:,:,idx(2));              % Randomly selected solution 2
        X3 = P(:,:,idx(3));              % Randomly selected solution 3
        V = X1 + F * (X2 - X3);         % Generating the donor vector

        %% Crossover
        del = randi(D, 1);              % Generating the random variable delta

        for j = 1:D
            if rand <= Pc || del == j % Check for donor vector or target vector
                U(i, j) = V(j);         % Accept variable from donor vector
            else
                U(i, j) = P(i, j);      % Accept variable from target vector
            end
        end
    end
    
    %% Bounding and Greedy Solution
    for j = 1:Np
        U(j, :) = min(ub, U(j, :));     % Bounding violating variables to upper bound
        U(j, :) = max(lb, U(j, :));     % Bounding violating variables to lower bound

        fu(j, :) = prob(U(j, :));       % Evaluating the fitness of the trial solution

        if all(fu(j, :) <= f(j, :)) && any(fu(j, :) < f(j, :)) % Greedy selection
            P(j, :) = U(j, :);          % Include the new solution in population
            f(j, :) = fu(j, :);         % Include the fitness functions value of the new solution
        end
    end
    
    if objectives == 2
        clf
        scatter(f(:, 1), f(:, 2), "filled");
        drawnow
    elseif objectives == 3
        clf
        scatter3(f(:, 1), f(:, 2), f(:, 3), "filled");
        drawnow
    end
end

if objectives == 1
    [bestfitness, ind] = min(f);
    bestsol = P(ind, :);

    disp(bestfitness);
    disp(bestsol);
    
    bestfitness = P;
    bestsol = f;
end
end


function [population, fitness] = calculateFitness(population)
    global eas;
    
    [population , fitness] = evaluate(population);

    [fitness] = rankingEvaluation(fitness);
    
end