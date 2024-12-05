function secondTask(exp_flag)
    global op;
    if nargin == 0
        exp_flag=0;
    end
    op.home_base = [0 0 0 0 0];

    op.plains = [20, 100];

    t1 = [25 -43.301 100 ];
    t2 = [25 43.301 100 ];
    t5 = [-25 43.301 100];
    t6 = [-25 -43.301 100];
    t3 = [-50 0 100 ];
    t4 = [50 0 100];

    op.targets = [  
                    
                    t3  0 -45;
                    t4  0 45;
                    t1 45 16;
                    t2 -45 16;
                    t6 45 -16;
                    t5 -45 -16;
                    ]; %target [x y z ux uy uz cone_angle]
                    % ]; %target [x y z ux uy uz cone_angle]
    op.obstacles = [
                    0 30 100 10 80;
                    0 -30 100 10 80;
                    26 15 100 10 80;
                    -26 15 100 10 80;
                    26 -15 100 10 80;
                    -26 -15 100 10 80;
                    
                    ]; %cylinder [x y z(base) radius height]

    op.n_links = 20;
    op.length_domain = [20 100];

    op.first_angle.is_fixed = true;
    op.angle_domain = [-45 45];
    op.first_angle.angle = 0;
    op.end_points = retrieveOrientationSegmentEndPoints3D(op.targets,op.obstacles,op.home_base);  % retrieve the end points for each target's orientation segment
    
    % % drawProblem3D([]);

    %---------------------EA SETTINGS---------------------    
    global eas;

    

    eas.bbbc.crunchMethod = 'com'; % for bbbc

    if ~exp_flag
        eas.n_generations = 100;
        eas.n_individuals = 100;
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

end