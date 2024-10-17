function experiment_main()
    
    %---------------------PROBLEM DEFINITION--------------------- 
    global op;
    global eas;

    %%Testing Creating a struct for each algorithm??

    %%Experiment Variables

    numOfIteration = 20;    %%The amount of iteration

    result.tasks = ["firstTask", "thirdTask"]; %%Type wanted task function's names
    
    algo_series = ["ga", "bbbc", "pso", "de"]; %% Type wanted algorithm types in here
    result.algorithms = algo_series;

    eas.n_generations = 20;
    eas.n_individuals = 10;
    eas.ga.crossover_probability = 1;
    eas.de.crossoverProbability = 1;
    eas.ga.mutation_method = 'random';
    eas.ga.mutation_probability = 0.2;  % -1 is dynamic 
    eas.survival_method = 'elitist_full'; % 'elitist_full', 'elitist_alpha', 'non-elitist'
    eas.ga.selection_method = 'tournament';    % 'tournament', 'proportionate'
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
            for i=1:numOfIteration
                tStart = tic;
                [best_chrom config fit_array]=main(1);
                tEnd = toc(tStart);
                fit_array(1,eas.fitIdx.parameterID) = 1;
                fit_array(1,eas.fitIdx.algo) = k;
                fit_array(1,eas.fitIdx.runTime) = tEnd;
                fit_array(1,eas.fitIdx.taskID) = TaskID;
                fit_array(1,eas.fitIdx.runID) = i;
                fit_array(1,eas.fitIdx.chromID) = count;
                
                result.output_matrix(count,:) = fit_array(1, :);
                result.chromosome_mat{count,1} = best_chrom;
                count = count+1;
            end
        end
    end
    save("exp1", result);
end