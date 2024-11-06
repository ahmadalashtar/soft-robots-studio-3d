function iteration(numOfIteration,count,TaskID,k,param,nameOfFile)
    global eas
    global op
    global result
    for i=1:numOfIteration
        tStart = tic;
        [best_chrom config fit_array]=main(1);
        tEnd = toc(tStart);
        fit_array(1,eas.fitIdx.algo) = k;
        fit_array(1,eas.fitIdx.runTime) = tEnd;
        fit_array(1,eas.fitIdx.taskID) = TaskID;
        fit_array(1,eas.fitIdx.runID) = i;
        fit_array(1,eas.fitIdx.chromID) = count;
        fit_array(1,eas.fitIdx.parameterInd1) = param(1);
        fit_array(1,eas.fitIdx.parameterInd2) = param(2);
        fit_array(1,eas.fitIdx.parameterInd3) = param(3);
        
        result.output_matrix(count,:) = fit_array(1, :);
        result.chromosome_mat{count,1} = best_chrom;
        count = count + 1;
        save(nameOfFile,'result');
    end
end