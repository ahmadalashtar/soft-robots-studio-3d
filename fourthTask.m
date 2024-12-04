function fourthTask()
    global op;          
    op.home_base = [0 0 0 0 0];

    op.plains = [20 100];

    t4 = [60 120 100];
    t5 = [120 60 100 ];
    t6 = [120 -60 100];
    t8 = [60 -120 100];
    op.targets = [  
                    
                    t4 -60 2.2;
                    t5 -4.3 60;
                    t6 4.3 60;
                    t8 60 2.2;
                 ]; 
% for i = 1:size(op.targets,1)
%     [rotx, roty] = getAngleForTask(op.targets(i,1:3), [0 0 0]);
%     op.targets(i,4) = rotx;
%     op.targets(i,5) = roty;
% end
    op.obstacles = [
                    20 50 100 10 80;
                    50 20 100 10 80;
                    50 -20 100 10 80;
                    20 -50 100 10 80;
                    
                    ]; %cylinder [x y z(base) radius height]

    op.n_links = 20;
    op.length_domain = [10 50];

    op.first_angle.is_fixed = true;
    op.angle_domain = [-45 45];
    op.first_angle.angle = 0;
    op.end_points = retrieveOrientationSegmentEndPoints3D(op.targets,op.obstacles,op.home_base);  % retrieve the end points for each target's orientation segment
    
    % % drawProblem3D([]);

    %---------------------EA SETTINGS---------------------    
    global eas;

    

    eas.bbbc.crunchMethod = 'com'; % for bbbc

    eas.n_generations = 100;
    eas.n_individuals = 100;
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