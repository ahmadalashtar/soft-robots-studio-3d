function decodeExperiment()
    clear all
    clc
    global op
    global eas
    load("exp15_11.mat");
    experiment_Index = 2056;

    eas = result.settings;

    chrom = result.chromosome_mat{experiment_Index};
    fitness = result.output_matrix(experiment_Index, :);

    task = result.tasks(fitness(eas.fitIdx.taskID));
    algo = result.algo_series(fitness(eas.fitIdx.algo));

    switch algo
        case "bbbc"
            fprintf('Task %s, Algorithm %s', task, algo);
        case "de"
            fprintf('Task %s, Algorithm %s| Variant: %d Scaling Factor: %.2f', ...
                            task, algo, result.parameters.de.variant(fitness(eas.fitIdx.parameterInd1)),result.parameters.de.scalingFactor(fitness(eas.fitIdx.parameterInd2)));
        case "ga"
            fprintf('Task %s, Algorithm %s | Mutation Probability: %.2f Crossover Alpha: %.2f', task, algo, result.parameters.ga.mutation_probability(fitness(eas.fitIdx.parameterInd1)), result.parameters.ga.crossover_alpha(fitness(eas.fitIdx.parameterInd2)));
        case "pso"
            fprintf('Task %s, Algorithm %s | Omega: %.2f Cognitive Constant: %.2f Social Constant: %.2f', ...
                                task, algo, result.parameters.pso.omega(fitness(eas.fitIdx.parameterInd1)), ...
                                result.parameters.pso.cognitiveConstant(fitness(eas.fitIdx.parameterInd2)), ...
                                result.parameters.pso.socialConstant(fitness(eas.fitIdx.parameterInd3)));
    end
    fprintf(' Runtime: %.2f\n', fitness(eas.fitIdx.runTime));
    switch task
        case "firstTask"
            firstTask(1);
        case "fourthTask"
            fourthTask(1);
        case "fifthTask"
            fifthTask(1);
    end

        config = decodeIndividual(chrom);
        drawProblem3D(config);
end