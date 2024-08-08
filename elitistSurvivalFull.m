%--------------ELITIST SURVIVAL, (MU+LAMBDA)-SCHEME --------------

%IMPORTANT: first merge both populations 'pop' and 'offspring', then it recalculate their rank (rank only makes sense within a population)
function [nextGenPop_final, fit_array_NGP] = elitistSurvivalFull(pop, offspring, fit_array_P, fit_array_O)
    global op;  % optimization problem
    global eas; % genetic algorithm settings
     
    nextGenPop = zeros(size(op.targets,1)*2+1,op.n_nodes+gas.extra_genes,eas.n_individuals*2);    % declare a static array of chromosomes filled with zeros
    fit_array_NGP = zeros(eas.n_individuals*2,length(fieldnames(gas.fitIdx)));                  % array containing fitness for each individual of the new population
    
    nextGenPop(:,:,1:eas.n_individuals) = pop;
    nextGenPop(:,:,eas.n_individuals+1:eas.n_individuals*2) = offspring;
    
    fit_array_O(:,gas.fitIdx.id) = fit_array_O(:,gas.fitIdx.id) + eas.n_individuals;
    
    fit_array_NGP(1:eas.n_individuals,:) = fit_array_P;
    fit_array_NGP(eas.n_individuals+1:eas.n_individuals*2,:) = fit_array_O;
    
    [fit_array_NGP] = rankingEvaluation(fit_array_NGP);
    fit_array_NGP(eas.n_individuals+1:eas.n_individuals*2,:) = [];
    
    
    nextGenPop_final = zeros(size(op.targets,1)*2+1,op.n_nodes+gas.extra_genes,eas.n_individuals);
    for i=1:eas.n_individuals 
        index = fit_array_NGP(i,gas.fitIdx.id);
        nextGenPop_final(:,:,i) = nextGenPop(:,:,index);
        fit_array_NGP(i,gas.fitIdx.id) = i;
    end
end
