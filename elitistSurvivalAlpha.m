%--------------ELITIST SURVIVAL, (ALPHA)-SCHEME --------------

%IMPORTANT: first merge both populations 'pop' and 'offspring', then it recalculate their rank (rank only makes sense within a population)
function [nextGenPop, fit_array_NGP] = elitistSurvivalAlpha(pop, offspring, fit_array_P, fit_array_O)
    global op;  % optimization problem
    global eas; % genetic algorithm settings
    
    n_elites = fix(gas.survival_alpha*eas.n_individuals/100);
    n_off = eas.n_individuals - n_elites;
     
    nextGenPop = zeros(size(op.targets,1)*2+1,op.n_nodes+gas.extra_genes,eas.n_individuals);    % declare a static array of chromosomes filled with zeros
    fit_array_NGP = zeros(eas.n_individuals,length(fieldnames(gas.fitIdx)));                  % array containing fitness for each individual of the new population
    
    fit_array_O(:,gas.fitIdx.id) = fit_array_O(:,gas.fitIdx.id) + eas.n_individuals;            % new id for offspring
    
    fit_array_NGP(1:n_elites,:) = fit_array_P(1:n_elites,:);
    fit_array_NGP(n_elites+1:n_elites+n_off,:) = fit_array_O(1:n_off,:);
    
    [fit_array_NGP] = rankingEvaluation(fit_array_NGP);
    
    
    
    for i=1:eas.n_individuals 
        index = fit_array_NGP(i,gas.fitIdx.id);
        if index <= eas.n_individuals 
            nextGenPop(:,:,i) = pop(:,:,index);
        else
            index = index - eas.n_individuals;
            nextGenPop(:,:,i) = offspring(:,:,index);
        end
        fit_array_NGP(i,gas.fitIdx.id) = i;
    end
end