% MAIN FUNCTION
%
% Optimization Problem defintion:
% > .home_base, [1x3]                   pose of the home base, array: [x , y , angle in deg (positive counterclockwise from x-axis)]
% > .targets, [tx3]                     pose of the target(s), matrix: [x , y , angle in deg (positive counterclockwise from x-axis)]
% > .obstacles, [ox3]                   pose of the obstacle(s), matrix: [x , y , radius]
% > .n_links, 1x1                       max number of nodes
% > .angle_domain, 2x1                  range of joint bending angles [min angle, max angle] (in deg)
% > .length_domain, 1x2                 length domain of each link: [min length required, max length] 
% > .first_angle                        data structure
%   | > .is_fixed, bool                 boolean, true if first angle from base is fixed, false otherwise
%   | > .first_angle.angle, 1x1         THIS MAKES NO SENSE I WILL PROBABLY REMOVE IT if first angle from base is fixed, max angle of the first joint (in deg) - will generate an angle in the range +-angle, which will start based on the orientation defined in the home base
% > .end_points, tx2                    contains the end point [x , y] of the segments starting from the target in the direction of the reaching orientation, used to solve the inverse kinematics
    
% Genetic Algorithm settings:
%  > .parallel                          boolean, true to run parallel computing
%  > .generations, 1x1                  number of iterations of the GA
%  > .n_individuals, 1x1                number of individuals in the population
%  > .selection_method                  selection method of the algortithm, can be: 'tournament', 'roulette', 'sus', 'random';
%  > .crossover_method                  crossover method of the algortithm, can be: 'blxa', 'sbx'
%  > .mutation_method                   mutation method of the algortithm, can be: 'non-uniform', 'polynomial', 'random'
%  > .survival_method                   survival method of the algortithm, can be: 'non-elitist', 'elitist', 'dynamic'
%  > .crossover probability             [0-1], probability to apply crossover to a pair of parents
%  > .mutation_probability, 1x1         mutation probability [0-1], probability to modify a gene in an individual (for each individuals and for each gene)
%                                       if set to -1, this will run the dynamic mutation decreasing the probability from 1.0 to 0.0 through generations     
%  > .verbose, bool                     boolean, if true prints out log for each epoch (number of epoch, best fitness of the epoch, variance in the population, best fit overall)
%  > .draw_plot, bool                   boolean, if true draws plot at the end of each epoch
%  > .extra_genes = 5                  number of extra genes for individual, it should be costant to 4 (check the function 'generateRandomChromosome' for more information)
%  > .variance_generations, 1x1         variation of the best individual is calculated over the last (number) of generations
%  > .normalize_weightDistance, bool    if true, while calculating the ik fitness, it will normalize the distances of each node from the orientation segment over the number of nodes (keep it to TRUE)
    
% Genetic Algorithm output:
%  > pop, t+1 x n+4 x n_individuals     last generation population
%  > fit_array, n_individuals x 4       fitness value, composed of 'ik fitness', 'number of nodes', 'rank fitness', 'index in the pop array' (check the function 'evaluate' for more information)

% NOTE FOR EXECUTION, if you want to check how individuals are evolving:
% > place a breakpoint at line 98 of 'runGeneticAlgorithm' as you run the script to pause it
% > execute 'drawProblem2D(decodeIndividual(pop(:,:,1)))'
% > remove breakpoint and continue the execution

function [best_chrom, configurations] = runIt()
    
    %---------------------PROBLEM DEFINITION--------------------- 
    global op;          % optimization problem
    op.plane_z = 1000;
    op.home_base = [0 0 0 0 0];

    t1 = [100 30 200 ];
    % t2 = [100 -30 200  ];
    % t3 = [50 50 50];
    
    %t2 = [100 100 100];
    %t3 = [-400 500 op.plane_z-53];
    % u1 = (op.home_base(1:3)-t1)/norm(op.home_base(1:3)-t1);
    % u2 = (op.home_base(1:3)-t2)/norm(op.home_base(1:3)-t2);
    % u3 = (op.home_base(1:3)-t3)/norm(op.home_base(1:3)-t3);
    % [x1, y1, ~] = vector2Angles(u1)
    % [x2, y2, ~] = vector2Angles(u2)
    % [x3, y3, ~] = vector2Angles(u3)
    op.targets = [ 
        % t1 180 5 ;
                    % t2 -30 -30 ;
                    t1 0 50;
                    % t2 0 50;
                    % t2 180 0;

                    ]; %target [x y z ux uy uz cone_angle]
                    % ]; %target [x y z ux uy uz cone_angle]
    op.obstacles = [
                     
                     100 100 100 20 100
                    ]; %cylinder [x y z(base) radius height]

    op.n_links = 10;
    op.length_domain = [10 50];

    op.first_angle.is_fixed = true;
    op.angle_domain = [-30 30];
    op.first_angle.angle = 0;
    op.end_points = retrieveOrientationSegmentEndPoints3D();  % retrieve the end points for each target's orientation segment
    disp(segment2UnitVector(op.targets(1,1:3),op.end_points(1,:)))
    
    % % drawProblem3D([]);

    %---------------------EA SETTINGS---------------------    
    global eas;

    

    eas.bbbc.crunchMethod = 'com'; % for bbbc

    eas.n_generations = 250;
    eas.n_individuals = 250;
    eas.obstacle_avoidance = false; % we'll do obstacle avoidace later
    eas.survival_method = 'elitist_alpha'; % 'elitist_full', 'elitist_alpha', 'non-elitist'
    eas.ga.selection_method = 'tournament';    % 'tournament', 'proportionate'
    eas.ga.crossover_method = 'blxa';  % 'blxa'
    eas.ga.crossover_probability = 0.9;
    eas.ga.mutation_method = 'random';   % 'random', 'modifiedRandom'
    eas.ga.mutation_probability = 0.4;  % -1 is dynamic 
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
    
    eas.rankingSettings.minFit = 0;     % OUTPUT min IK fitness
    eas.rankingSettings.maxFi = 0;      % OUTPUT max IK fitness  FIX THE TYPO
    eas.rankingSettings.delta = 0;      % OUTPUT difference between max and min IK fitness
    eas.rankingSettings.n_partitions = 0;       % OUTPUT overall number of partitions (delta/step_ik)
    eas.rankingSettings.firstPartitionSize = 0; % OUTPUT number of individuals falling in the first partition (best ones)

    eas.draw_plot = false;  % if you set this to true, your computer will likely explode
    eas.verbose = true;
    eas.normalize_weightDistance = true;    % deprecated
    eas.variance_generations = 10; 
    
    eas.stopAtVariance_flag = false;    % if true, GA will stop when variance between solutions becomes < 0.000 (number of zeros are defined..
    eas.stopAtVariance_zeros = 2;       % ...here)
    eas.stopAtFitness_flag = false;     % if true, GA will stop when IK fitness becomes < 0.000 (number of zeros are defined..
    eas.stopAtFitness_zeros = 2;        % ...here)
    
    eas.infeasible_subcount = 0;
    eas.convergence0 = 0;
    eas.convergence00 = 0;
    
    % indices for fit_array, these are constants do not change!

    eas.fitIdx.ikMod = 1;
    eas.fitIdx.nodes = 2;           % number of links to reach the target's orientation segment (overall sum)
    eas.fitIdx.wiggly = 3;          % percentage of ondulation of the configuration (avg among configurations)
    eas.fitIdx.nodesOnSegment = 4;  % number of links on the target's orientation segment (overall sum)
    eas.fitIdx.totLengthMod = 5;
    eas.fitIdx.ik = 6;              % IK fitness (avg among configurations)
    eas.fitIdx.totLength = 7;       % total length of the robot (avg among configurations - maybe we should use max?)
    eas.fitIdx.pen = 8;             % penalty for constraints
    eas.fitIdx.rank = 9;            % rank, used as fitness for selection and survival operators
    eas.fitIdx.id = 10;             % reference to chromosome in the array of population
    % extra genes in chromosome, it is a constant do not change!

    eas.extra_genes = 4;

    rng shuffle;

    if eas.ga.mutation_probability == 1
        typeOfMut = "Dynamic";
    else
        typeOfMut = round(eas.ga.mutation_probability,2);
    end

    pop = [];
    fit_array = [];
    
    eas.algorithm = "de"; % ga, bbbc, pso, or de

    switch eas.algorithm
        case "ga"
            [pop, fit_array] = runGeneticAlgorithm(1);
        case "bbbc"
            [pop, fit_array] = runBBBC(1);
        case "pso"
            [pop, fit_array] = runPSO(1);
        case "de"
            [pop, fit_array] = runDE(1);
    end

    best_index = fit_array(1,eas.fitIdx.id);
    best_chrom = pop(:,:,best_index);
    
    configurations = decodeIndividual(best_chrom);
    drawProblem3D(configurations);
    
    if fit_array(1,eas.fitIdx.pen) == 0
        isBestFeasible = "feas";
    else
        isBestFeasible = "unfeas";
    end
    r=1; %this is for experiments to keep track of which run we are executing. remove when running experiments
    tit = "RUN: " + num2str(r) + ", IK: " + num2str(fit_array(1,eas.fitIdx.ik)) + ", LtS: " + num2str(fit_array(1,eas.fitIdx.nodes)) + ", OND: " + num2str(fit_array(1,eas.fitIdx.wiggly)) + "%, LoS: " + num2str(fit_array(1,eas.fitIdx.nodesOnSegment)) + ", " + isBestFeasible + ", pop: " + eas.n_individuals + ", mut: " + typeOfMut;
    title(tit); 
end