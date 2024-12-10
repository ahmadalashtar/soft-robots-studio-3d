% % 11 algorithm 
% % 13 task 
function splitData()
[chroms, fit] = combineExp();
save("chroms");
save("fit_overall(4200).mat","fit");

nTasks = 3;
algorithms = ["bbbc","ga","de","pso"];
% split tasks
for i = 1 : nTasks
    indices  = fit(:,13)==i;
    task = fit(indices,:);
    save("fit_task"+num2str(i)+"(1400)","task");
end

% split algorithms
for i = 1 : nTasks
    clear task;
    load("fit_task"+num2str(i)+"(1400).mat");
    for j = 1 : size(algorithms,2)
        clear indices;
        indices = task(:,11)==j;
        taskAlg = task(indices,:);
        save("fit_task"+num2str(i)+"(" + algorithms(j) + ").mat","taskAlg");
    end
end
end