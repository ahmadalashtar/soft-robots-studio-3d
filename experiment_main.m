function experiment_main()
    clear all
    clc
    %---------------------PROBLEM DEFINITION--------------------- 
    global op;
    global eas;
    global result;

    %%Testing Creating a struct for each algorithm??

    %%Experiment Variables

    nameOfFile = "result";
    numOfIteration = 2;    %%The amount of iteration
    
    result.tasks = ["firstTask", "fourthTask", "fifthTask"]; %%Type wanted task function's names
    
    algo_series = ["bbbc" "de" "pso" "ga"]; %% Type wanted algorithm types in here %"bbbc","ga","pso","de"
    result.algorithms = algo_series;
       
    eas.obstacle_avoidance = false; % we'll do obstacle avoidace later
    eas.rankingSettings.step_ik = 0.5;       % resolution of a partition (i.e., distance in IK fitness between two consecutives paritions)
    eas.rankingSettings.step_len = 5;


    eas.n_generations = 6;
    eas.n_individuals = 10;
    eas.survival_method = 'elitist_full'; % 'elitist_full', 'elitist_alpha', 'non-elitist'
    eas.crossover_method = "blxa";
    eas.survival_alpha = 40;
    eas.penalty_method = 'static';	% 'static', 'deb'
    eas.ranking_method = "penalty";
    
    eas.fitIdx.algo = 11;           % type of algorithm that we are using
    eas.fitIdx.runTime = 12;        % running time in seconds
    eas.fitIdx.taskID = 13;         % reference to task number
    eas.fitIdx.runID = 14;          % reference to iteration number
    eas.fitIdx.chromID = 15;        % reference to chromosome number
    eas.fitIdx.parameterInd1 = 16;    % first parameter options index
    eas.fitIdx.parameterInd2 = 17;    % second parameter options index
    eas.fitIdx.parameterInd3 = 18;    % third parameter options index

    % extra genes in chromosome, it is a constant do not change!
    %%GA Parameters
    eas.ga.crossover_method = 'blxa';  % 'blxa'
    eas.ga.crossover_probability = 1;
    eas.ga.mutation_method = 'random';
    eas.ga.mutation_probability = 0.2;  % -1 is dynamic 
    eas.ga.selection_method = 'tournament';    % 'tournament', 'proportionate'
    %%DE Parameters
    eas.de.crossoverProbability = 1;
    eas.de.scalingFactor = 0.85;
    eas.de.variant = [1 2 3 4 5 6]; % 1: rand/1 2: best/1 3: rand/2 4: best/2 5: current-to-best/1 6: current-to-rand/1
    %%PSO Parameters
    eas.pso.omega = 0.75;
    eas.pso.cognitiveConstant = 1;
    eas.pso.socialConstant = 2;


   

    %%Parameters Array

    result.parameters.ga.mutation_probability = [-1 0.2 0.4 0.6];
    result.parameters.ga.crossover_alpha = [0.5 0.419 0.381]; 

    result.parameters.de.variant = [1 2 3 4 5 6]; %%Find paper for all
    result.parameters.de.scalingFactor = [0.5  0.75 1.0];

    result.parameters.pso.omega = [0.6  0.8  1.0];
    result.parameters.pso.cognitiveConstant = [2.0 2.5 5.0];
    result.parameters.pso.socialConstant = [0.5 1.0 1.5];

   
    %%If entered file name is exist start the code from where it got
    %%interruptted. We should implement that as well to prevent any
    %%interventions

    result.output_matrix= zeros(numOfIteration*length(algo_series)*length(result.tasks),18); %% Output matrix will store every iteration on every settings
    result.chromosome_mat = [];
    
    % Initialize a counter for total iterations and a variable to track the current iteration
    total_iterations = 0;
    iteration_count = 0;
    count = 1;
    
    % Step 1: Calculate total number of iterations for progress tracking
    for TaskID = 1:length(result.tasks)
        switch result.tasks(TaskID)
            case "firstTask"
                firstTask(1);
            case "fourthTask"
                fourthTask(1);
            case "fifthTask"
                fifthTask(1);
        end
        
        % Calculate the total number of iterations for the current task
        for k = 1:length(algo_series)
            eas.algorithm = algo_series(k);
            
            switch eas.algorithm
                case "ga"
                    total_iterations = total_iterations + ...
                        length(result.parameters.ga.mutation_probability) * ...
                        length(result.parameters.ga.crossover_alpha);
                case "de"
                    total_iterations = total_iterations + ...
                        length(result.parameters.de.variant) * ...
                        length(result.parameters.de.scalingFactor);
                case "pso"
                    total_iterations = total_iterations + ...
                        length(result.parameters.pso.omega) * ...
                        length(result.parameters.pso.cognitiveConstant) * ...
                        length(result.parameters.pso.socialConstant);
                case "bbbc"
                    total_iterations = total_iterations + 1;
            end
        end
    end

    save(nameOfFile,'result');
    for TaskID = 1:length(result.tasks)
        %%After each task, clear all so DE doesnt crash
        switch result.tasks(TaskID)
            case "firstTask"
                firstTask(1);
            case "secondTask"
                secondTask(1);
            case "thirdTask"
                thirdTask(1);
            case "fourthTask"
                fourthTask(1);
            case "fifthTask"
                fifthTask(1);
        end
        for k = 1:length(algo_series)
            eas.algorithm = algo_series(k);
            %%There will be another for loop for parameters here
            switch eas.algorithm
                case "ga"
                    for a = 1:length(result.parameters.ga.mutation_probability)
                        eas.ga.mutation_probability = result.parameters.ga.mutation_probability(a);
                        
                        for z = 1:length(result.parameters.ga.crossover_alpha)
                                eas.ga.crossover_alpha = result.parameters.ga.crossover_alpha(z);
                                
                                iteration_count = iteration_count + 1;
                                %Print Progress
                                fprintf('Task %d, Algorithm %s | Mutation Probability: %.2f Crossover Alpha: %.2f Completion Percentage: %.2f%%\n', ...
                                TaskID, eas.algorithm, eas.ga.mutation_probability, ...
                                eas.ga.crossover_alpha, (iteration_count / total_iterations) * 100);

                                iteration(numOfIteration,count,TaskID,k, [a z 0], nameOfFile);
                                count = count + numOfIteration;
                        end

                    end
                case "de"
                    for b = 1:length(result.parameters.de.variant)
                        for b_2 = 1:length(result.parameters.de.scalingFactor)
                            
                            eas.de.variant = result.parameters.de.variant(b);
                            eas.de.scalingFactor = result.parameters.de.scalingFactor(b_2);

                            iteration_count = iteration_count + 1;
                            % Print progress
                            fprintf('Task %d, Algorithm %s| Variant: %d Scaling Factor: %.2f Completion Percentage: %.2f%%\n', ...
                            TaskID, eas.algorithm,result.parameters.de.variant(b),result.parameters.de.scalingFactor(b_2),(iteration_count / total_iterations) * 100);

                            iteration(numOfIteration,count,TaskID,k, [b b_2 0], nameOfFile);
                            count = count + numOfIteration;

                        end
                    end
                    
                case "pso"
                    fprintf("Beginning PSO\n");
                    for c = 1:length(result.parameters.pso.omega)
                        
                        for c_2 = 1:length(result.parameters.pso.cognitiveConstant)

                            for c_3 = 1:length(result.parameters.pso.socialConstant)
                                eas.pso.omega = result.parameters.pso.omega(c);
                                eas.pso.cognitiveConstant = result.parameters.pso.cognitiveConstant(c_2);
                                eas.pso.socialConstant = result.parameters.pso.socialConstant(c_3);

                                iteration_count = iteration_count + 1;
                                % Print progress

                                fprintf('Task %d, Algorithm %s | Omega: %.2f Cognitive Constant: %.2f Social Constant: %.2f Completion Percentage: %.2f%%\n', ...
                                TaskID, eas.algorithm, result.parameters.pso.omega(c), ...
                                result.parameters.pso.cognitiveConstant(c_2), ...
                                result.parameters.pso.socialConstant(c_3), ...
                                (iteration_count / total_iterations) * 100);

                                
                                iteration(numOfIteration,count,TaskID,k, [c c_2 c_3], nameOfFile);
                                count = count + numOfIteration;
                                
                            end
                        end
                    end

                case "bbbc"

                    iteration_count = iteration_count + 1;
                    % Print progress
                    fprintf('Task %d, Algorithm %s: %.2f%% Complete\n', ...
                    TaskID, eas.algorithm, (iteration_count / total_iterations) * 100);

                    iteration(numOfIteration,count,TaskID,k, [0 0 0], nameOfFile);
                    count = count + numOfIteration;

            end
        end
    end
    spy()
end