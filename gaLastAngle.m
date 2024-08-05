function [best_chrom] = gaLastAngle(best_chrom,individuals,generations,eta_c,eta_m,mutation_probability)
    targets = (size(best_chrom,1)-1)/2;
    lengths = best_chrom(size(best_chrom,1),:);
    for i = 1 : 2 : targets * 2
        best_chrom(i:i+1,:) = main(generations,individuals,[best_chrom(i:i+1,:);lengths],ceil(i/2),eta_c,eta_m,mutation_probability);
    end
end

function [best_chrom] = main(generations,individuals,t_chrom,target_id,eta_c,eta_m,mutation_probability)
    pop = randomPop(individuals);
    pop = evaluate(pop,t_chrom,target_id);
    for i = 1 : generations
        matingPool = selection(pop);
        offsprings = variation(matingPool,eta_c,eta_m,mutation_probability);
        offsprings = evaluate(offsprings,t_chrom,target_id);
        pop = survive(pop,offsprings);
    end
    [~, indices] = sort([pop.fitness]);
    sortedPop = pop(indices);
    best_angle_chrom = sortedPop(1);
    best_chrom = best_angle_chrom.getRobotChrom(t_chrom);
    best_chrom = best_chrom(1:2,:);
    
end

function [pop] = randomPop(individuals)
    pop(individuals) = Chrom();
    for i = 1 : individuals
        pop(i) = randomChrom();
    end
end

function [new_chrom] = randomChrom()
    chrom = rand(1,2);
    chrom = chrom * 180 * 2 - 180;
    new_chrom = Chrom();
    new_chrom.x = chrom(1);
    new_chrom.y = chrom(2);
end

function [new_pop] = evaluate(pop,t_chrom,target_id)
    individuals = size(pop,2);
    for i  = 1 : individuals
        pop(i).fitness = pop(i).evaluate(t_chrom,target_id);
    end
    new_pop = pop;
end

function [matingPool] = selection(pop)
    individuals = size(pop,2);
    matingPool(individuals) = Chrom();
    for i = 1 : individuals
        index_1 = randi([1 individuals]);
        index_2 = randi([1 individuals]);
        if pop(index_1).fitness <= pop(index_2).fitness
            matingPool(i) = pop(index_1);
        else
            matingPool(i) = pop(index_2);
        end
    end
end

function [offsprings]  = variation(matingPool,eta_c,eta_m,mutation_probability)
    individuals = size(matingPool,2);
    offsprings(individuals) = Chrom();
    for i = 1 : 2 : individuals
        [o1x, o2x] = crossover(matingPool(i).x,matingPool(i+1).x,eta_c,180,-180);

        o1x = mutation(o1x, eta_m, 180,-180, mutation_probability);
        o2x = mutation(o2x, eta_m, 180,-180, mutation_probability);

        offsprings(i).x = o1x;
        offsprings(i+1).x = o2x;
        
        [o1y, o2y] = crossover(matingPool(i).y,matingPool(i+1).y,eta_c,180,-180);

        o1y = mutation(o1y, eta_m, 180,-180, mutation_probability);
        o2y = mutation(o2y, eta_m, 180,-180, mutation_probability);

        offsprings(i).y = o1y;
        offsprings(i+1).y = o2y;
    end
end

function [o1,o2] = crossover(p1,p2,eta_c,upper_bound,lower_bound)
    u = rand();
    if u <= 0.5
        beta = (2*u)^(1/(eta_c+1));
    else
        beta = (1/(2*(1-u)))^(1/(eta_c+1));
    end
    p_bar = (1/2)*(p1+p2);
    
    o1 = p_bar - (1/2)*beta*(p2-p1);
    o2 = p_bar + (1/2)*beta*(p2-p1);

    o1 = min(max(o1, lower_bound), upper_bound);
    o2 = min(max(o2, lower_bound), upper_bound);
end

function [mutated_o] = mutation(o, eta_m, upper_bound, lower_bound, mutation_prob)
    mutated_o = o;
    if rand <= mutation_prob
        u = rand();
        if u < 0.5
            delta = (2 * u)^(1 / (eta_m + 1)) - 1;
        else
            delta = 1 - (2 * (1 - u))^(1 / (eta_m + 1));
        end
        mutated_o = o + delta * (upper_bound - lower_bound);
        mutated_o = min(max(mutated_o, lower_bound), upper_bound);
    end
end

function [newPop]  = survive(pop,matingPool)
    individuals = size(pop,2);
    entirePop = [pop matingPool];
    [~, indices] = sort([entirePop.fitness]);
    sortedPop = entirePop(indices);
    newPop = sortedPop(1:individuals);
end