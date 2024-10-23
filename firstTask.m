function firstTask(exp_flag)
    global op;
    if nargin == 0
        exp_flag=0;
    end
    op.home_base = [0 0 0 0 0];

    t1 = [145 -30 115 ];
    t2 = [145 30 115 ];
    op.targets = [  t1 -15 75;
                    t2 15 75;
                    ]; %target [x y z ux uy uz cone_angle]
                    % ]; %target [x y z ux uy uz cone_angle]
    op.obstacles = [
                    85 0 200 12.5 300;
                    45 56.79492 200 12.5 300;
                    45 -56.79492 200 12.5 300;
                    145 -30 200 12.5 80;
                    145 30 200 12.5 80;
                    ]; %cylinder [x y z(base) radius height]

    op.n_links = 20;
    op.length_domain = [25 100];

    op.first_angle.is_fixed = true;
    op.angle_domain = [-45 45];
    op.first_angle.angle = 0;
    op.end_points = retrieveOrientationSegmentEndPoints3D(op.targets,op.obstacles,op.home_base);  % retrieve the end points for each target's orientation segment
    
    % % drawProblem3D([]);

    %---------------------EA SETTINGS---------------------    
    global eas;

    

    eas.bbbc.crunchMethod = 'com'; % for bbbc

    if ~exp_flag
        eas.n_generations = 10;
        eas.n_individuals = 10;
        eas.survival_method = 'elitist_full'; % 'elitist_full', 'elitist_alpha', 'non-elitist'
        eas.ga.selection_method = 'tournament';    % 'tournament', 'proportionate'
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
        eas.de.variant = 2; % 1: rand/1 2: best/1 3: rand/2 4: best/2 5: current-to-best/1 6: current-to-rand/1
    
        % settings of rank partitioning algorithm
        eas.ranking_method = 'penalty';     % 'penalty', 'separation'
    end

end