function experiment_main(data)
    clear op eas result
    clc
    %---------------------PROBLEM DEFINITION--------------------- 
    global op;
    global eas;
    global result;
	
	algorithms = string(data.algo)';
    tasks = string(data.task)';
    ComputerID = string(data.id);
    
    %%Testing Creating a struct for each algorithm??

    %%Experiment Variables
	nameOfFile = strcat("exp-testing", ComputerID);
    nameOfFile = strcat('experiments/', nameOfFile, '.mat');
    if isfile(nameOfFile)
        load(nameOfFile);
        if result.completeness == "DONE"
            return
        end
        eas = result.settings;
        eas.currTaskID = result.output_matrix(end, 13);
        eas.currAlgo = result.output_matrix(end, 11);
        eas.currIteration = result.output_matrix(end, 14);
        eas.currParameterArray = result.output_matrix(end, 16:18);
        eas.count = result.output_matrix(end, 15);
    else
        
        result.tasks = tasks; %%Type wanted task function's names
        
        result.algo_series = algorithms; %% Type wanted algorithm types in here %"bbbc","ga","pso","de"
           
        eas.obstacle_avoidance = false; % we'll do obstacle avoidace later
        eas.rankingSettings.step_ik = 0.5;       % resolution of a partition (i.e., distance in IK fitness between two consecutives paritions)
        eas.rankingSettings.step_len = 5;
    
        eas.adaptive_size = 10;
        eas.adaptive_pen_mult = 50;
		
		
        eas.numOfIteration = data.runs;    %%The amount of iteration
        eas.n_generations = data.generation;
        eas.n_individuals = data.pop;
		if(isfield(data, 'elitist'))
			eas.survival_method = data.elitist; % 'elitist_full', 'elitist_alpha', 'non-elitist'
		else
			eas.survival_method = 'non-elitist'; % 'elitist_full', 'elitist_alpha', 'non-elitist'
		end
        eas.crossover_method = "blxa";
        eas.survival_alpha = 40;
        eas.penalty_method = 'adaptive';	% 'static', 'deb','adaptive' 
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
		if(isfield(data, 'mut'))
			result.parameters.ga.mutation_probability = data.mut;
			result.parameters.ga.crossover_alpha = data.cross; 
		end
		if(isfield(data, 'variant'))
			result.parameters.de.variant = data.variant; 
			result.parameters.de.scalingFactor = data.scalingFactor;
		end
		
		if(isfield(data, 'omega'))
			result.parameters.pso.omega = data.omega;
			result.parameters.pso.cognitiveConstant = data.cognitiveConstant;
			result.parameters.pso.socialConstant = data.socialConstant;
		end
    
       
        %%If entered file name is exist start the code from where it got
        %%interruptted. We should implement that as well to prevent any
        %%interventions
    
        result.output_matrix= zeros(1,18); %% Output matrix will store every iteration on every settings
        result.chromosome_mat = [];
        
        % Initialize a counter for total iterations and a variable to track the current iteration
        eas.iteration_count = 0;
        eas.count = 1;
        eas.currTaskID = 1;
        eas.currAlgo = 1;
        eas.currParameterArray = [1 1 1];
        eas.currIteration = 1;
        result.settings = eas;
        result.completeness = "in progress";
        save(nameOfFile,'result');
    end
    
    total_iterations = 0;
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
        for k = 1:length(result.algo_series)
            eas.algorithm = result.algo_series(k);
            
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

    for TaskID = eas.currTaskID:length(result.tasks)
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
        for k =eas.currAlgo:length(result.algo_series)
            eas.algorithm = result.algo_series(k);
            %%There will be another for loop for parameters here
            switch eas.algorithm
                case "ga"
                    tic;
                    fprintf("*** Beginning ga ***\n");
                    for a = eas.currParameterArray(1):length(result.parameters.ga.mutation_probability)
                        
                        for z = eas.currParameterArray(2):length(result.parameters.ga.crossover_alpha)

                            eas.ga.mutation_probability = result.parameters.ga.mutation_probability(a);
                            eas.ga.crossover_alpha = result.parameters.ga.crossover_alpha(z);
                            
                            

                            iteration(TaskID,k, [a z 0], nameOfFile);
                            eas.iteration_count = eas.iteration_count + 1;
                            %Print Progress
                            fprintf('Task %d, Algorithm %s | Mutation Probability: %.2f Crossover Alpha: %.2f Completion Percentage: %.2f%%\n', ...
                            TaskID, eas.algorithm, eas.ga.mutation_probability, ...
                            eas.ga.crossover_alpha, (eas.iteration_count / total_iterations) * 100);
                            eas.currIteration = 1;
                            if z == length(result.parameters.ga.crossover_alpha)
                               eas.currParameterArray(2) = 1;
                            end
                        end

                    end
                    elapsedTime = toc;
                    fprintf("*** Finished ga ***\n");
                    fprintf('Total Execution Time: %.2f seconds\n', elapsedTime);
                                        

                case "de"
                    tic;
                    fprintf("Beginning de\n");
                    for b = eas.currParameterArray(1):length(result.parameters.de.variant)
                        for b_2 = eas.currParameterArray(2):length(result.parameters.de.scalingFactor)
                            
                            eas.de.variant = result.parameters.de.variant(b);
                            eas.de.scalingFactor = result.parameters.de.scalingFactor(b_2);
                          
                            iteration(TaskID,k, [b b_2 0], nameOfFile);
                            eas.iteration_count = eas.iteration_count + 1;
                            % Print progress
                            fprintf('Task %d, Algorithm %s| Variant: %d Scaling Factor: %.2f Completion Percentage: %.2f%%\n', ...
                            TaskID, eas.algorithm,result.parameters.de.variant(b),result.parameters.de.scalingFactor(b_2),(eas.iteration_count / total_iterations) * 100);

                            eas.currIteration = 1;
                            if b_2 == length(result.parameters.de.scalingFactor)
                               eas.currParameterArray(2) = 1;
                            end
                        end
                    end
                    elapsedTime = toc;
                    fprintf("*** Finished de ***\n");
                    fprintf('Total Execution Time: %.2f seconds\n', elapsedTime);
                case "pso"
                    fprintf("Beginning PSO\n");
                    tic;
                    for c = eas.currParameterArray(1):length(result.parameters.pso.omega)
                        
                        for c_2 = eas.currParameterArray(2):length(result.parameters.pso.cognitiveConstant)

                            for c_3 = eas.currParameterArray(3):length(result.parameters.pso.socialConstant)
                                eas.pso.omega = result.parameters.pso.omega(c);
                                eas.pso.cognitiveConstant = result.parameters.pso.cognitiveConstant(c_2);
                                eas.pso.socialConstant = result.parameters.pso.socialConstant(c_3);

                                
                                iteration(TaskID,k, [c c_2 c_3], nameOfFile);
                                eas.iteration_count = eas.iteration_count + 1;
                                % Print progress

                                fprintf('Task %d, Algorithm %s | Omega: %.2f Cognitive Constant: %.2f Social Constant: %.2f Completion Percentage: %.2f%%\n', ...
                                TaskID, eas.algorithm, result.parameters.pso.omega(c), ...
                                result.parameters.pso.cognitiveConstant(c_2), ...
                                result.parameters.pso.socialConstant(c_3), ...
                                (eas.iteration_count / total_iterations) * 100);
                                eas.currIteration = 1;
                                if c_3 == length(result.parameters.pso.socialConstant)
                                    eas.currParameterArray(3) = 1;
                                end
                            end
                            if c_2 == length(result.parameters.pso.cognitiveConstant)
                                eas.currParameterArray(2) = 1;
                            end

                        end
                        
                    end
                    elapsedTime = toc;
                    fprintf("*** Finished pso ***\n");
                    fprintf('Total Execution Time: %.2f seconds\n', elapsedTime);
                case "bbbc"
                    tic;
                    fprintf("Beginning bbbc\n");

                    iteration(TaskID,k, [0 0 0], nameOfFile);
                    eas.iteration_count = eas.iteration_count + 1;
                    % Print progress
                    fprintf('Task %d, Algorithm %s: %.2f%% Complete\n', ...
                    TaskID, eas.algorithm, (eas.iteration_count / total_iterations) * 100);
                    eas.currIteration = 1;
                    elapsedTime = toc;
                    fprintf("Finished bbbc\n");
                    fprintf('Total Execution Time: %.2f seconds\n', elapsedTime);

            end
            eas.currParameterArray = [1 1 1];
        end
        eas.currAlgo = 1;
    end
    fprintf("*** FINISHED EXPERIMENT ***");
    result.completeness = "DONE";
    save(nameOfFile, "result");
    spy()
end