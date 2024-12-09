function fitness = rankPartitionExperiments()
fliesWithRef = dir("exp-testing136");
files = fliesWithRef(3:end);
chroms = cell(100,1);
count = 1;
fitness = double.empty(0,18);
for i = 1 : size(files,1)
    clear result;
    load(files(i).name);
    if result.algo_series == "bbbc"
        col11 = 1;
        col16 = 0; % first parameter
        col17 = 0; % second parameter
        col18 = 0; % third parmeter
    elseif result.algo_series == "ga"
        col11 = 2;
        col16 = result.parameters.ga.mutation_probability; % first parameter
        col17 = result.parameters.ga.crossover_alpha; % second parameter
        col18 = 0; % third parmeter
    elseif result.algo_series == "de"
        col11 = 3;
        col16 = result.parameters.de.variant; % first parameter
        col17 = result.parameters.de.scalingFactor; % second parameter
        col18 = 0; % third parmeter
    elseif result.algo_series == "pso"
        col11 = 4;
        col16 = result.parameters.pso.omega; % first parameter
        col17 = result.parameters.pso.cognitiveConstant; % second parameter
        col18 = result.parameters.pso.socialConstant; % third parmeter
    end
    rows = size(result.output_matrix,1);
    for j = 1 : rows
        result.output_matrix(j,15) = count;
        chroms{count,1} = result.chromosome_mat{j,1};
        count = count + 1;
    end
    result.output_matrix(:,11) = col11;
    result.output_matrix(:,16) = col16;
    result.output_matrix(:,17) = col17;
    result.output_matrix(:,18) = col18;
    fitness = [fitness ;  result.output_matrix];
end
% [fitness] = rankingEvaluation(fitness);
end
