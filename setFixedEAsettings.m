function [] = setFixedEAsettings()
    %---------------------EA SETTINGS---------------------    
    global eas;
    eas.bbbc.crunchMethod = 'com'; % for bbbc

    eas.n_generations = 200;
    eas.n_individuals = 350;
    eas.survival_method = 'non-elitist'; % 'elitist_full', 'elitist_alpha', 'non-elitist'
    eas.ga.selection_method = 'tournament';    % 'tournament', 'proportionate'
    eas.ga.crossover_probability = 1.0;
    eas.ga.crossover_alpha = 0.419;
    eas.ga.mutation_method = 'random';   % 'random', 'modifiedRandom'
    eas.ga.mutation_probability = -1;  % -1 is dynamic 
    eas.survival_alpha = 40;    %this is the percentage of elites that will stay in the new population
    eas.penalty_method = 'static';	% 'static', 'adaptive'
    
    eas.pso.omega = 0.75;
    eas.pso.cognitiveConstant = 1;
    eas.pso.socialConstant = 2;
    eas.pso.globalBest = struct('position',[],'fitness',[]);
    
    eas.de.scalingFactor = 0.85;
    eas.de.crossoverProbability = 0.8;
    eas.de.variant = 2; % 1: rand/1 2: best/1 3: rand/2 4: best/2 5: current-to-best/1 6: current-to-rand/1

    % settings of rank partitioning algorithm
    eas.ranking_method = 'penalty';     % 'penalty', 'separation'
end