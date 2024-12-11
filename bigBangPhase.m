function [pop] = bigBangPhase(cMass, gen)
    global op;  % optimization problem
    global eas; % big bang - big crunch algorithm settings
    
    % declare a static array of individuals filled with zeros
    pop = zeros(size(op.targets,1)*2+1,op.n_links+eas.extra_genes,eas.n_individuals);
    for i=1:1:eas.n_individuals
        indv = generateRandomIndividualBBBC(cMass, gen);   
        pop(:,:,i) = indv;
    end
    pop(1:end-1,1,:) = 0;
end