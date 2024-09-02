% Perform ranking of the population: divide the population into partitions based on how good their fitness is, and then sort the number of nodes within each partition to minimize it.
%
% INPUT/OUTPUT: 
% 'fit_array', is a matrix with fitness values
function [fit_array] = rankingEvaluation(fit_array)
    global eas; % genetic algorithm settings
    
    n_individuals = size(fit_array,1);  % the number of individuals will double during survival thats why we should dynamically check how many individuals we are ranking!

    switch eas.algorithm
        case "ga"
            switch eas.ranking_method
                case 'penalty'
                    [fit_array, eas.rankingSettings] = doPartitioning_simplified(fit_array, eas.rankingSettings, eas.fitIdx);
                case 'separation'
                    fit_array = sortrows(fit_array,[eas.fitIdx.pen, eas.fitIdx.ik]);          % sort fitness matrix by penalty and then ik
            
                    % count feasible solutions
                    for i = 1:1:n_individuals
                        if fit_array(i,eas.fitIdx.pen) ~= 0 
                            countFS = i-1;
                            break;
                        end
                    end
        
                    if ~exist('countFS','var')
                        countFS = n_individuals; % all feasible solutions - I know it is a little intricate to understand this and I hate it too
                    end
        
                    % separate feasible from unfeasible arrays
                    fit_array_feasible = fit_array(1:countFS,:);
                    fit_array_unfeasible = fit_array((countFS+1):size(fit_array,1),:);
        
                    %fit_array_unfeasible = sortrows(fit_array_unfeasible,[gas.fitIdx.nodes,gas.fitIdx.ik]);   % unfeasible solutions are part of a single partition, so all of them are ranked together
        
                    switch countFS
                        case 0
                            % there are no feasible solutions, partition unfeasible
                            [fit_array_unfeasible, eas.rankingSettings] = doPartitioning(fit_array_unfeasible, eas.rankingSettings, eas.fitIdx);
                        case 1
                            % there is only one feasible solution, add the only feasible and partition only unfeasible
                            [fit_array_unfeasible, eas.rankingSettings] = doPartitioning(fit_array_unfeasible, eas.rankingSettings, eas.fitIdx);
                        case n_individuals - 1 
                            % there is only one unfeasible solution, do partitioning only to feasible and then append the only unfeasible
                            [fit_array_feasible, eas.rankingSettings] = doPartitioning(fit_array_feasible, eas.rankingSettings, eas.fitIdx);
                        case n_individuals
                            % there are no unfeasible solution, do partitioning only to feasible and then append the only unfeasible (which is empty)
                            [fit_array_feasible, eas.rankingSettings] = doPartitioning(fit_array_feasible, eas.rankingSettings, eas.fitIdx);
                        otherwise
                            % there are more feasible solutions, partition both feasible and unfeasible
                            [fit_array_unfeasible, eas.rankingSettings] = doPartitioning(fit_array_unfeasible, eas.rankingSettings, eas.fitIdx);
                            [fit_array_feasible, eas.rankingSettings] = doPartitioning(fit_array_feasible, eas.rankingSettings, eas.fitIdx);
                    end
                    fit_array = [fit_array_feasible ; fit_array_unfeasible];    % merge feasible and unfeasible solutions
                otherwise
                    error('Unexpected Ranking Method.');
            end
            
            % partition fitness is given by a numerical rank
            % such that each individual has a larger fitness than the previous one
            % this ranks each individual
            for i=1:1:n_individuals
                fit_array(i,eas.fitIdx.rank) = i;
            end    
    end
    
end