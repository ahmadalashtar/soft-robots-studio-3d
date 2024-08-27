load("Fit.mat")
load("Pop.mat")
load("Gen.mat")
load("EtaC.mat")
load("EtaM.mat")
load("Mut.mat")
Pop  = Pop';
Gen = Gen';
EtaC = EtaC';
EtaM = EtaM';
Mut = Mut';
populationsp = [50 100 500];
generationsp = [50 100 500];
eta_csp = [2 15 25];
eta_msp = [10 50 100];
mutation_probabilityp = [0.1 0.2 0.4];

% Perform n-way ANOVA
[p, tbl, stats] = anovan(Fit, {Pop, Gen, EtaC, EtaM, Mut}, ...
                         'model', 'interaction', ...
                         'varnames', {'Population', 'Generation', 'Eta_c', 'Eta_m', 'Mutation_Prob'});

% Display the results
disp('ANOVA Table:');
disp(tbl);

disp('P-values:');
disp(p);

disp('stats:');
disp(stats);


% Perform multiple comparison tests using Bonferroni-Dunn procedure
[c,m,h,gnames] = multcompare(stats, 'CType', 'bonferroni');
gnamesTable = array2table(m,"RowNames",gnames, ...
    "VariableNames",["Mean","Standard Error"])
% Display results
disp('Multiple Comparison Results using Bonferroni-Dunn:');
disp(c);

% Extract significant comparisons
significant_comparisons = c(c(:, 6) < 0.05, :);
disp('Significant Comparisons:');
disp(significant_comparisons);

% Find best parameter values based on mean fitness
best_params = struct();
unique_pop = unique(Pop);
unique_gen = unique(Gen);
unique_etaC = unique(EtaC);
unique_etaM = unique(EtaM);
unique_mut = unique(Mut);

% Calculate mean fitness for each parameter value
mean_fitness_pop = arrayfun(@(x) mean(Fit(Pop == x)), unique_pop)
mean_fitness_gen = arrayfun(@(x) mean(Fit(Gen == x)), unique_gen)
mean_fitness_etaC = arrayfun(@(x) mean(Fit(EtaC == x)), unique_etaC)
mean_fitness_etaM = arrayfun(@(x) mean(Fit(EtaM == x)), unique_etaM)
mean_fitness_mut = arrayfun(@(x) mean(Fit(Mut == x)), unique_mut)


% Select the best parameter value based on minimum fitness
[~, best_pop_idx] = min(mean_fitness_pop);
[~, best_gen_idx] = min(mean_fitness_gen);
[~, best_etaC_idx] = min(mean_fitness_etaC);
[~, best_etaM_idx] = min(mean_fitness_etaM);
[~, best_mut_idx] = min(mean_fitness_mut);

best_params.Population = unique_pop(best_pop_idx);
best_params.Generation = unique_gen(best_gen_idx);
best_params.Eta_c = unique_etaC(best_etaC_idx);
best_params.Eta_m = unique_etaM(best_etaM_idx);
best_params.Mutation_Prob = unique_mut(best_mut_idx);

disp('Best Parameters based on Bonferroni-Dunn Post-Hoc Test:');
disp(best_params);

% disp("All combinations:")
combinations = cell(3^5,1);
index = 0;
for i = 1 : 3
    for j = 1 : 3
        for k = 1: 3
            for l = 1 : 3
                for m = 1 :3
                    index = index + 1;
                    f.Population = populationsp(i);
                    f.Generation = generationsp(j);
                    f.Eta_c = eta_csp(k);
                    f.Eta_m = eta_msp(l);
                    f.Mutation_Probability = mutation_probabilityp(m);
                    f.Mean = (mean_fitness_pop(i)+mean_fitness_gen(j)+mean_fitness_etaC(k)+mean_fitness_etaM(l)+mean_fitness_mut(m))/5;
                    combinations{index} = f;
                end
            end
        end
    end
end


% Extract the .Mean values from each struct
meanValues = cellfun(@(x) x.Mean, combinations);

% Sort the mean values and obtain the indices
[sortedMeanValues, sortIdx] = sort(meanValues);

% Reorder the cell array based on sorted indices
sortedCellArray = combinations(sortIdx);

% for i = 1 : 10
%     disp(sortedCellArray{i})
% end

std_fitness_pop = arrayfun(@(x) std(Fit(Pop == x)), unique_pop)
std_fitness_gen = arrayfun(@(x) std(Fit(Gen == x)), unique_gen)
std_fitness_etaC = arrayfun(@(x) std(Fit(EtaC == x)), unique_etaC)
std_fitness_etaM = arrayfun(@(x) std(Fit(EtaM == x)), unique_etaM)
std_fitness_mut = arrayfun(@(x) std(Fit(Mut == x)), unique_mut)



