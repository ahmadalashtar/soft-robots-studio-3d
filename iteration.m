function iteration(TaskID,k,param,nameOfFile)
    global eas
    global op
    global result
    for i=eas.currIteration:result.settings.numOfIteration
        tStart = tic;
        [best_chrom config fit_array]=main(1);
        tEnd = toc(tStart);
        fit_array(1,eas.fitIdx.algo) = k;
        fit_array(1,eas.fitIdx.runTime) = tEnd;
        fit_array(1,eas.fitIdx.taskID) = TaskID;
        fit_array(1,eas.fitIdx.runID) = i;
        fit_array(1,eas.fitIdx.chromID) = eas.count;
        fit_array(1,eas.fitIdx.parameterInd1) = param(1);
        fit_array(1,eas.fitIdx.parameterInd2) = param(2);
        fit_array(1,eas.fitIdx.parameterInd3) = param(3);
        
        result.output_matrix(eas.count,:) = fit_array(1, :);
        result.chromosome_mat{eas.count,1} = best_chrom;
        eas.count = eas.count + 1;
        result.settings = eas;
        save(nameOfFile,'result');
    end
end