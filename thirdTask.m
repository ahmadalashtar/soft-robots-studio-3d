function thirdTask()
    global op;          
    op.home_base = [0 0 0 0 0];

    t1 = [-80 40 100 ];
    t2 = [-80 -40 100 ];
    t3 = [-40 80 100];
    t4 = [40 80 100];
    t5 = [80 40 100 ];
    t6 = [80 -40 100];
    t7 = [-40 -80 100];
    t8 = [40 -80 100];
    op.targets = [  
                    
                    t1 -60 -20;
                    t2 60 -20;
                    t3 -60 -55;
                    t4 -60 55;
                    t5 -60 20;
                    t6 60 20;
                    t7 55 -60;
                    t8 55 60;

                    ]; %target [x y z ux uy uz cone_angle]
                    % ]; %target [x y z ux uy uz cone_angle]
    op.obstacles = [
                    -50 20 100  10 80;
                    -50 -20 100 10 80;
                    -20 50 100 10 80;
                    20 50 100 10 80;
                    50 20 100 10 80;
                    50 -20 100 10 80;
                    -20 -50 100 10 80;
                    20 -50 100 10 80;
                    
                    ]; %cylinder [x y z(base) radius height]

    op.n_links = 20;
    op.length_domain = [5 40];

    op.first_angle.is_fixed = true;
    op.angle_domain = [-45 45];
    op.first_angle.angle = 0;
    op.end_points = retrieveOrientationSegmentEndPoints3D(op.targets,op.obstacles,op.home_base);  % retrieve the end points for each target's orientation segment
    
    % % drawProblem3D([]);

    %---------------------EA SETTINGS---------------------    
    global eas;

    

    eas.bbbc.crunchMethod = 'com'; % for bbbc

    eas.n_generations = 2;
    eas.n_individuals = 2;
    eas.obstacle_avoidance = false; % we'll do obstacle avoidace later
    eas.survival_method = 'elitist_full'; % 'elitist_full', 'elitist_alpha', 'non-elitist'
    eas.ga.selection_method = 'tournament';    % 'tournament', 'proportionate'
    eas.ga.crossover_method = 'blxa';  % 'blxa'
    eas.ga.crossover_probability = 0.8;
    eas.ga.mutation_method = 'random';   % 'random', 'modifiedRandom'
    eas.ga.mutation_probability = 0.2;  % -1 is dynamic 
    eas.survival_alpha = 40;    %this is the percentage of elites that will stay in the new population
    eas.penalty_method = 'static';	% 'static', 'deb'
    
    eas.pso.omega = 0.75;
    eas.pso.cognitiveConstant = 1;
    eas.pso.socialConstant = 2;
    eas.pso.globalBest = struct('position',[],'fitness',[]);
    
    eas.de.scalingFactor = 0.85;
    eas.de.crossoverProbability = 0.8;
    eas.de.variant = 1; % 1: rand/1 2: best/1 3: rand/2 4: best/2 5: current-to-best/1 6: current-to-rand/1

    % settings of rank partitioning algorithm
    eas.ranking_method = 'penalty';     % 'penalty', 'separation'
    eas.rankingSettings.step_ik = 0.5;       % resolution of a partition (i.e., distance in IK fitness between two consecutives paritions)
    eas.rankingSettings.step_len = 5;

end