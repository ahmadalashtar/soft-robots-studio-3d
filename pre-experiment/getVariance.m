function getVariance(nFiles,bandWidth,generations)
    % ikMod = 1;
    % nodes = 2;
    % wiggly = 3;
    % nodesOnSegment = 4;
    % totLengthMod = 5;
    % ik = 6;
    % totLength = 7;
    % pen = 8;
    rows = generations-bandWidth+1;
    columns = 8;
    for i = 1 : nFiles
        variance = zeros(rows,columns);
        load("fitness"+num2str(i));
        fitnessPerGeneration(:,9:end) = [];
        for j = 1:columns
            for k = 1:rows
                variance(k,j) = var(fitnessPerGeneration(k:k+bandWidth-1,j));
            end
            
        end
        save("variance"+num2str(i),"variance")
    end
    plotter(nFiles);
end