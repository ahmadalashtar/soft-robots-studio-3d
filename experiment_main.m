function experiment_main()
    
    %---------------------PROBLEM DEFINITION--------------------- 
    global op;
    global eas;
    global result;

    %%Testing Creating a struct for each algorithm??

    %%Experiment Variables
    
    numOfIteration = 10;    %%The amount of iteration

    result.tasks = ["firstTask", "thirdTask"]; %%Type wanted task function's names
    
    algo_series = ["pso"]; %% Type wanted algorithm types in here
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
    
    eas.fitIdx.parameterID = 11;    % reference to parameter which is using
    eas.fitIdx.algo = 12;           % type of algorithm that we are using
    eas.fitIdx.runTime = 13;        % running time in seconds
    eas.fitIdx.taskID = 14;         % reference to task number
    eas.fitIdx.runID = 15;          % reference to iteration number
    eas.fitIdx.chromID = 16;        % reference to chromosome number
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
    eas.de.variant = 1; % 1: rand/1 2: best/1 3: rand/2 4: best/2 5: current-to-best/1 6: current-to-rand/1
    %%PSO Parameters
    eas.pso.omega = 0.75;
    eas.pso.cognitiveConstant = 1;
    eas.pso.socialConstant = 2;


    %%Parameters Array

    result.parameters.omega = [0.6 0.7 0.8 0.9 1.0];
    result.parameters.cognitiveConstant = [2.0 2.4 2.8 3.2 3.6 4.0 4.4 4.8 5.2];
    result.parameters.socialConstant = [0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5];
    result.parameters.variant = [1 2 3 4 5];
    result.parameters.scalingFactor = [0.5 0.6 0.7 0.8 0.9 1.0];
    result.parameters.mutation_probability = [-1 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1];

    result.output_matrix= zeros(numOfIteration*length(algo_series)*length(result.tasks),16); %% Output matrix will store every iteration on every settings
    result.chromosome_mat = [];
    count = 1;
    for TaskID = 1:length(result.tasks)
        switch result.tasks(TaskID)
            case "firstTask"
                firstTask(1);
            case "secondTask"
                secondTask(1);
            case "thirdTask"
                thirdTask(1);
        end
        for k = 1:length(algo_series)
            eas.algorithm = algo_series(k);
            %%There will be another for loop for parameters here
            switch eas.algorithm
                case "ga"
                    for a = 1:length(result.parameters.mutation_probability)
                        eas.ga.mutation_probability = result.parameters.mutation_probability(a);
                        iteration(numOfIteration,count,TaskID,k);
                        count = count + numOfIteration;
                    end
                case "de"
                    for b = 1:length(result.parameters.variant)
                        for b_2 = 1:length(result.parameters.scalingFactor)
                            
                            eas.de.variant = result.parameters.variant(b);
                            eas.de.scalingFactor = result.parameters.scalingFactor(b_2);
                            iteration(numOfIteration,count,TaskID,k);
                            count = count + numOfIteration;

                        end
                    end
                    
                case "pso"
                    for c = 1:length(result.parameters.omega)
                        
                        for c_2 = 1:length(result.parameters.cognitiveConstant)

                            for c_3 = 1:length(result.parameters.socialConstant)
                                eas.pso.omega = result.parameters.omega(c);
                                eas.pso.cognitiveConstant = result.parameters.cognitiveConstant(c_2);
                                eas.pso.socialConstant = result.parameters.socialConstant(c_3);
                                iteration(numOfIteration,count,TaskID,k);
                                count = count + numOfIteration;
                                
                            end
                        end
                    end

                case "bbbc"
                    iteration(numOfIteration,count,TaskID,k);
                    count = count + numOfIteration;

                 end

            % for i=1:numOfIteration
            %     tStart = tic;
            %     [best_chrom config fit_array]=main(1);
            %     tEnd = toc(tStart);
            %     fit_array(1,eas.fitIdx.parameterID) = 1;
            %     fit_array(1,eas.fitIdx.algo) = k;
            %     fit_array(1,eas.fitIdx.runTime) = tEnd;
            %     fit_array(1,eas.fitIdx.taskID) = TaskID;
            %     fit_array(1,eas.fitIdx.runID) = i;
            %     fit_array(1,eas.fitIdx.chromID) = count;
            % 
            %     result.output_matrix(count,:) = fit_array(1, :);
            %     result.chromosome_mat{count,1} = best_chrom;
            %     count = count+1;
            % end
        end        
    end
    save('result','result');
    spy()
end