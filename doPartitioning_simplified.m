function [fit_array, rank_info] = doPartitioning_simplified(fit_array, rank_info, fitIdx) 

%     min_ik = min(fit_array(:,fitIdx.ik));
%     min_length = min(fit_array(:,fitIdx.totLength));
%     fit_array(:,fitIdx.ikMod) = fit_array(:,fitIdx.ik) - mod(fit_array(:,fitIdx.ik)-min_ik,rank_info.step_ik);
%     fit_array(:,fitIdx.totLengthMod) = fit_array(:,fitIdx.totLength) - mod(fit_array(:,fitIdx.totLength)-min_length,rank_info.step_len);

    fit_array(:,fitIdx.ikMod) = fit_array(:,fitIdx.ik) - mod(fit_array(:,fitIdx.ik),rank_info.step_ik);
    fit_array(:,fitIdx.totLengthMod) = fit_array(:,fitIdx.totLength) - mod(fit_array(:,fitIdx.totLength),rank_info.step_len);
    
    fit_array = sortrows(fit_array,[fitIdx.ikMod, fitIdx.nodes, fitIdx.wiggly, fitIdx.nodesOnSegment, fitIdx.totLengthMod]);
    
    diff_array = [zeros(1,fitIdx.totLengthMod);abs(fit_array(1:end-1,1:fitIdx.totLengthMod)-fit_array(2:end,1:fitIdx.totLengthMod))];
    diff_array=sum(diff_array,2);
    
    start = 1;
    for i=1:1:size(fit_array,1)
        if diff_array(i) > 0
            stop = i;
            fit_array(start:stop-1,:) = sortrows(fit_array(start:stop-1,:),[fitIdx.ik, fitIdx.totLength]);
            start = stop;
        end
    end
    
    rank_info.firstPartitionSize = sum(fit_array(:,fitIdx.ikMod)==fit_array(1,fitIdx.ikMod));
    rank_info.minFit = fit_array(1,fitIdx.ikMod); 
end

% 'fit_array' is composed as follows, for each individual in the population:
%
% -> first element is the fitness from the inverse kinematics (ik fitness), calculated as the normalized sum of the distances of each node from the target's orientation segment, overall sum for each configuration
% -> second element is the sum of all nodes used to reach the target, overall sum for each configuration
% -> third element is the rank based on the partitions to minimize the number of nodes (rank fitness) + the penality for constraint violation
% -> fourth element is the index of the individual with respect of the array 'pop', as this matrix is sorted by the third column and the order will not be the same as the individuals in the population
