function iteration(numOfIteration,count,TaskID,k)
    global eas
    global op
    global result
    for i=1:numOfIteration
        tStart = tic;
        [best_chrom config fit_array]=main(1);
        tEnd = toc(tStart);
        fit_array(1,eas.fitIdx.parameterID) = 1;
        fit_array(1,eas.fitIdx.algo) = k;
        fit_array(1,eas.fitIdx.runTime) = tEnd;
        fit_array(1,eas.fitIdx.taskID) = TaskID;
        fit_array(1,eas.fitIdx.runID) = i;
        fit_array(1,eas.fitIdx.chromID) = count;
        
        result.output_matrix(count,:) = fit_array(1, :);
        result.chromosome_mat{count,1} = best_chrom;
        count = count + 1;
    end
end