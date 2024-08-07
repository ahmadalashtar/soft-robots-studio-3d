%--------------TOURNAMENT SELECTION--------------

function [matPool] = tournament(fit_array, k, isMin)
    global eas; % genetic algorithm settings
    
    matPool = zeros(gas.n_individuals,1);
    for i=1:gas.n_individuals
        matPool(i) = getTournamentWinner(fit_array, k, isMin);
    end
end

function [winner] = getTournamentWinner(fit_array, k, isMin)
	global eas; % genetic algorithm settings

    bestFit = 0;
    winner = 0;
    for j=1:k
        index = ceil((gas.n_individuals)*rand);
        if j==1
            bestFit = fit_array(index,1);
            winner = fit_array(index,2);
        else
            if isMin == true
                % for minimization problems
                if bestFit > fit_array(index,1)
                    bestFit = fit_array(index,1);
                    winner = fit_array(index,2);
                end
            else
                % for maximization problems
                if bestFit < fit_array(index,1)
                    bestFit = fit_array(index,1);
                    winner = fit_array(index,2);
                end
            end
        end
    end
end