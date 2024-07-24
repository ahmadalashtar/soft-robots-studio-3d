function [fit_array, rank_info] = doPartitioning(fit_array, rank_info, fitIdx)
    fit_array = sortrows(fit_array, fitIdx.ik);
    rank_info.minFit = fit_array(1,fitIdx.ik);                            % get min ik fitness value from feasible solutions
    rank_info.maxFit = fit_array(end,fitIdx.ik);     % get max ik fitness value from feasible solutions
    rank_info.delta = rank_info.maxFit - rank_info.minFit;                                    % range between max and min ik fitness values
    rank_info.n_partitions = fix(rank_info.delta / rank_info.step_ik);
    rank_info.firstPartitionSize = 0;
    
    if rank_info.delta == 0
        %they are all the same, do nothing
    else
        % each partition will define uniformily distribuited ranges starting from min ik fitness up to max ik fitness with steps of value 'step'
        parts = ones(rank_info.n_partitions,1);                          % upper bounds of partitions are stored in an array
        parts(1) = rank_info.minFit + rank_info.step_ik;                   % first bound is [min, min+step]
        for i=2:1:rank_info.n_partitions
            parts(i) = parts(i-1) + rank_info.step_ik;           % creates all bounds
        end

        % this portion of code will divide the fitness matrix into partitions
        % and sort each partition based on number of nodes (from small to large)
        start = 1;
        for p=1:1:rank_info.n_partitions
            d = parts(p);
            stop = 1;
            for j=start:1:size(fit_array,fitIdx.ik)
                if fit_array(j,fitIdx.ik) > d
                    stop = j;
                    break;
                end
            end
            % sort by nodes to get to segment, ondulation, nodes on segment, overall length, ik fitness
            fit_array(start:stop-1,:) = sortrows(fit_array(start:stop-1,:),[fitIdx.nodes, fitIdx.wiggly, fitIdx.nodesOnSegment, fitIdx.totLength, fitIdx.ik]);
            %fit_array(start:stop-1,:) = sortrows(fit_array(start:stop-1,:),[fitIdx.wiggly, fitIdx.nodes, fitIdx.nodesOnSegment, fitIdx.totLength, fitIdx.ik]);
            start = stop;
            if p==1
                rank_info.firstPartitionSize = stop-1;
            end
        end
    end
end