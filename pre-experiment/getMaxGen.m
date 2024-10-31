function maxGen = getMaxGen(nFiles,threshold)
    stopsAt = zeros(1,nFiles);
    for i = 1 : nFiles
            load("variance"+num2str(i));
            for j = size(variance,1):-1:1
                if sum(variance(j,:)) > threshold
                    stopsAt(i) = j;
                    break;
                end
            end
    end
    maxGen = mean(stopsAt);
end