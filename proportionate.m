function [matPool] = proportionate(fit_array, isMin)
    global eas; % genetic algorithm settings
    
    if isMin == true
        fit_array(:,1) = flip(fit_array(:,1));  % for minimization, rank must be flipped
    end
    s = sum(fit_array(:,1));
    
    % calculate probability
    for i = 1:1:eas.n_individuals
        if i==1
            fit_array(i,1) = fit_array(i,1)/s;
        else
            fit_array(i,1) = fit_array(i,1)/s + fit_array(i-1,1);
        end
    end
    
    % fill mating pool
    matPool = zeros(eas.n_individuals,1);
    for i = 1:1:eas.n_individuals
        r = rand();
        for j = 1:1:eas.n_individuals
            if fit_array(j,1) >= r
                matPool(i) = fit_array(j,2);
                break;
            end
        end
    end
    
end