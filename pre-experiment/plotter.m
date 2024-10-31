function plotter(nFiles)
    
    for i = 1 : nFiles
        load("variance"+num2str(i));
        subplot(4,5,i);
        plot(300:size(variance,1),variance(300:end,:));
        ylim([0 10])
    end
end