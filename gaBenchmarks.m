function gaBenchmarks()
    global op;
    populations = [50 100 500];
    generations = [50 100 500];
    eta_cs = [2 15 25];
    eta_ms = [10 50 100];
    mutation_probability = [0.1 0.2 0.4];
    index = 0;
    Pop = zeros(3^5,1);
    Gen = zeros(3^5,1);
    EtaC = zeros(3^5,1);
    EtaM = zeros(3^5,1);
    Mut = zeros(3^5,1);
    Fit = zeros(3^5,1);
    for p = 1 : size(populations,2)
        for g = 1 : size(generations,2)
            for ec = 1 : size(eta_cs,2)
                for em = 1 : size (eta_ms,2)
                    for mp = 1: size(mutation_probability,2)
                        decreased_distance = 0;
                        % increased_distance = 0;
                        % n_decreases = 0;
                        % n_increases = 0;
                        index = index+1;
                        for i = 1 : 20
                            chrom = generateRandomChromosome;
                            [chrom, ~] = calculateFitness3D(chrom, 0);
                            % confs = decodeIndividual(chrom);
                            % end_points = solveForwardKinematics3D(confs,op.home_base,false);
                            nodes_deployed = chrom(1,size(chrom,2)-1);
                            target = op.targets(1,:);
                            % without_ga = norm(end_points(nodes_deployed+1,:)-target(1:3));
                            chrom = gaLastAngle(chrom,populations(p),generations(g),eta_cs(ec),eta_ms(em),mutation_probability(mp));
                            confs = decodeIndividual(chrom);
                            end_points = solveForwardKinematics3D(confs,op.home_base,false);
                            with_ga = norm(end_points(nodes_deployed+1,:)-target(1:3));
                            distance = with_ga;
                            % if distance>= 0
                            decreased_distance = decreased_distance + distance ;
                            %     n_decreases = n_decreases + 1;
                            % else
                            %     increased_distance = increased_distance + distance;
                            %     n_increases = n_increases + 1;
                            % end
                        end
                        disp(num2str(index) + " / " + 3^5)
                        Pop(index) = populations(p);
                        Gen(index) = generations(g);
                        EtaC(index) = eta_cs(ec);
                        EtaM(index) = eta_ms(em);
                        Mut(index) = mutation_probability(mp);
                        Fit(index) = decreased_distance/20;
                        % disp("-------------------------------------------------")
                        % disp("Population:")
                        % disp(populations(p))
                        % disp("Generation:")
                        % disp(generations(g))
                        % disp("Mutation Probability")
                        % disp(mutation_probability(mp))
                        % disp("eta_c")
                        % disp(eta_cs(ec))
                        % disp("eta_m")
                        % disp(eta_ms(em))
                        % disp("decreased distance on average:")
                        % average_decreased_distance = decreased_distance/20;
                        % disp(average_decreased_distance)
                        % % disp("increased distance on average:")
                        % % average_increased_distance = increased_distance/n_increases;
                        % % disp(average_increased_distance)
                    end
                end
            end
        end
    end
    save("Pop")
    save("Gen")
    save("EtaC")
    save("EtaM")
    save("Mut")
    save("Fit")
end