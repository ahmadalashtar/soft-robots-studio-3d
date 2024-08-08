% Add a penalty factor to infeasible solutions (degrade their fitness).
%
% INPUT:
% 'chrom' is the chromosome [t+1 x n+4] to be evaluated (extra genes should not be empty)
% 'fit_array' 
% 'draw_plot' is a boolean flag, true if you want to plot the segments from targets (currently not used, but it might be useful in the future?)
%
% OUTPUT:
% 'fit_array' 
function [fit_array] = checkConstraints(pop, fit_array)
    global eas; % genetic algorithm settings
            switch eas.penalty_method
                case 'static'
                    for i=1:eas.n_individuals
                        index = fit_array(i,eas.fitIdx.id);
                        fit_array(i,eas.fitIdx.pen) = calculateStaticPenalty(pop(:,:,index),[10 10 10 10 10 10 100 10]);
                        if eas.ranking_method == "penalty"
                            fit_array(i,eas.fitIdx.ik) = fit_array(i,eas.fitIdx.ik) + fit_array(i,eas.fitIdx.pen);
                        end
                    end

            end

end



%--------------DEB'S PENALTY METHOD--------------            
function [fit_array] = addDebsPenalty(fit_array)          
    global op;  % optimization problem
    global eas; % genetic algorithm settings

    % get the worst feasible solution's fitness
    worstFit = 0;
    bestFit = fit_array(1, 1);
    areThereFeasibleSolutions = false;
    for i = 1:1:eas.n_individuals
        if fit_array(i, 2) == 0 % if it is feasible
            if worstFit < fit_array(i, 1)
                worstFit = fit_array(i, 1);
                areThereFeasibleSolutions = true;
            end
        end
        if bestFit > fit_array(i, 1)
            bestFit = fit_array(i, 1);
        end
    end
    
    % if there are no feasible solutions, then we should get the best of the unfeasible solutions as baseline
    if areThereFeasibleSolutions == false
        worstFit = bestFit;
    end
    
    % add penalty
    for i = 1:1:eas.n_individuals
        if(fit_array(i, 2) ~= 0)    % if it is unfeasible    
            fit_array(i,3) = worstFit + fit_array(i, 2);
            fit_array(i,3) = fit_array(i,3) + fit_array(i, 1); % this part is not in Deb's formulation, but without it the ranking algorithm might not work!
        end
    end
end

% %--------------POWELL AND SKOLNICK'S PENALTY METHOD was deprecated--------------
% 
% function [fit_array] = pownskolpenalty(chrom, fit_array)
%     global eas; % genetic algorithm settings
%     global op;
%     
%     worstfeas = 0;
%     bestinfeas = 0;
%     indnum = gas.n_individuals;
%     while indnum > 0                  % this function is to find the worst feasible individual's fitness
%         if(fit_array(indnum, 5) == 0)
%             worstfeas = fit_array(indnum, 3);
%             break
%         end
%         indnum = indnum - 1;
%     end
% 
%     indnum = 1;
%     while indnum < gas.n_individuals                 
%         if(fit_array(indnum, 5) ~= 0)
%             bestinfeas = fit_array(indnum, 3);
%             break
%         end
%         indnum = indnum + 1;
%     end
% 
%      for i = 1:1:gas.n_individuals
%         if(fit_array(i, 5) ~= 0)    % calculates the fitnesses of nonfeasible individuals
%             fit_array(i,3) = fit_array(i,3) +  fit_array(i, 5) + abs( worstfeas -bestinfeas);
%         end
%      end
%      fit_array(:,5) = [];
% 
% end