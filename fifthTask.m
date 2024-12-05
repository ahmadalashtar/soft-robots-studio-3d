function fifthTask(exp_flag)
    global op;
    if nargin == 0
        exp_flag = 0;
    end
    op.home_base = [0 0 0 0 0];
    
    t1 = [75 -70 50 ];
    t2 = [75 -50 50 ];
    t3 = [75 -30 50 ];
    t4 = [75 -10 50];
    t5 = [75 10 50 ];
    t6 = [75 30 50];
    t7 = [75 50 50];
    t8 = [75 70 50];
    op.targets = [  
                    t1 0 0;
                    t2 0 0;
                    t3 0 0;
                    t4 0 0;
                    t5 -28.8 29.6;
                    t6 -32.005383208083494 25.004301778398400;
                    t7 36 30;
                    t8 28.8 29.6;

                    ]; %target [x y z ux uy uz cone_angle]
                    % ]; %target [x y z ux uy uz cone_angle]
for i = 1:size(op.targets,1)
    [rotx, roty] = getAngleForTask(op.targets(i,1:3), [0 0 0]);
    op.targets(i,4) = rotx;
    op.targets(i,5) = roty;

end
    op.plains = [-25 125];
    op.obstacles = [
                    25 -5  50 5 75;
                    25 5   50 5 75;
                    25 -22   50 5 75;
                    25 22   50 5 75;
                    25 -40   50 5 75;
                    25 40   50 5 75;
                    25 -50   50 5 75;
                   25 50   50 5 75;
                    ]; %cylinder [x y z(base) radius height]

    op.n_links = 20;
    op.length_domain = [5 25];

    op.first_angle.is_fixed = true;
    op.angle_domain = [-45 45];
    op.first_angle.angle = 0;
    op.end_points = retrieveOrientationSegmentEndPoints3D(op.targets,op.obstacles,op.home_base);  % retrieve the end points for each target's orientation segment
    
    % % drawProblem3D([]);

    %---------------------EA SETTINGS---------------------    
    global eas;

    

    eas.bbbc.crunchMethod = 'com'; % for bbbc

    if ~exp_flag
        eas.n_generations = 500;
        eas.n_individuals = 200;
        eas.obstacle_avoidance = false; % we'll do obstacle avoidace later
        eas.survival_method = 'elitist_full'; % 'elitist_full', 'elitist_alpha', 'non-elitist'
        eas.ga.selection_method = 'tournament';    % 'tournament', 'proportionate'
        eas.ga.crossover_method = 'blxa';  % 'blxa'
        eas.ga.crossover_probability = 1;
        eas.ga.mutation_method = 'random';   % 'random', 'modifiedRandom'
        eas.ga.mutation_probability = -1;  % -1 is dynamic 
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
function [rotx, roty] = getAngleForTask(target, obstacle)
v = target-obstacle;

    x = v(1);
    y = v(2);
    z = v(3);
    
    theta_x = rad2deg(atan2(y, z));
    
    R_x = [1, 0, 0;
           0, cosd(theta_x), -sind(theta_x);
           0, sind(theta_x), cosd(theta_x)];
    v_rot_x = (R_x * v')';
    
    theta_y = -rad2deg(atan2(v_rot_x(1), v_rot_x(3)));
    
    rotx = -theta_x;
    roty = -theta_y;
end