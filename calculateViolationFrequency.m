function frequency_weights = calculateViolationFrequency(population)
    global op;  % optimization problem
    global eas; % genetic algorithm settings

    frequency_beta = 1000;

    n_targets = size(op.targets,1);
    min_angle_x = op.angle_domain(1);
    max_angle_x = op.angle_domain(2);
    min_angle_y = op.angle_domain(1);
    max_angle_y = op.angle_domain(2);
    min_length = op.length_domain(1);

    freq_array = zeros(8);
    
    for i=1:eas.n_individuals
        
        chrom = population(:,:,i);
        n_links = size(chrom,2) - eas.extra_genes;

        for i = 1:2:n_targets*2

            targetIndex = ceil(i/2);
            final_angle_x = chrom(i,n_links+2);
            final_angle_y = chrom(i+1,n_links+2);
            last_link_length = chrom(i,n_links+4);

            if ceil(abs(min(0,final_angle_x - min_angle_x))) ~= 0
               freq_array(1) = freq_array(1) + 1;
            end

            if ceil(abs(min(0,max_angle_x - final_angle_x))) ~= 0
                freq_array(2) = freq_array(2) + 1;
            end

            if ceil(abs(min(0,final_angle_y - min_angle_y))) ~= 0
                freq_array(3) = freq_array(3) + 1;
            end

            if ceil(abs(min(0,max_angle_y - final_angle_y))) ~= 0
                freq_array(4) = freq_array(4) + 1;
            end

            linksOnSegment = chrom(i,n_links+3) - (chrom(i,n_links+1)-1);
            if linksOnSegment <= 1
                freq_array(5) = freq_array(5) + 1;
            end


            configurations = decodeIndividual(chrom);
            conf = configurations(:,:,ceil(i/2));
            [nodes] = solveForwardKinematics3D(conf,op.home_base,0);
            
        
            target = op.targets(targetIndex,1:3);
            epsilonIndex = chrom(i,n_links+1);
            epsilonNode = nodes(epsilonIndex,:);
            endPoint = op.end_points(targetIndex,:);
        
            %translate the epsildon, target, and its endpoint to the origin, so
            %that the target is on the origin 0 0 0
            endPoint = endPoint - target;
            epsilonNode = epsilonNode - target;
        
            % calculate the angle between A the target and epsilon and B the
            % target and its endpoint
            codAngle = dot(epsilonNode,endPoint)/(norm(epsilonNode)*norm(endPoint));
            angle = acosd(codAngle);

            if isnan(angle) || angle >= 90
                freq_array(6) = freq_array(6) + 1;
            end

            %--CONSTRAINT 7: no collision with obstacles
            
            % check intersections for every segment of each configuration of the robot
        
            intersections = collisionCheck(nodes, op.obstacles,chrom(i,n_links+3), op.planes);

            if intersections ~= 0
                freq_array(7) = freq_array(7) + 1;
            end

            for j = 2:1:epsilonIndex

                currNode = nodes(j,:);
                if j-1 < 1
                    prevNode = nodes(j,:);
                    nexNode = nodes(j+1,:);
                elseif j+1 > epsilonIndex
                    prevNode = nodes(j-1,:);
                    nexNode = nodes(j,:);
                else
                    prevNode = nodes(j-1,:);
                    nexNode = nodes(j+1,:);
                end
        
                collisioning = pathVectors(transpose(prevNode), transpose(currNode), transpose(nexNode), op.length_domain(1), op.obstacles);
        
        
                if (collisioning)
                    freq_array(8) = freq_array(8) + 1;
                    break;
                end
            end


        end
    end
    
    % calculate the proportinate of constraint violations

    freq_array(:) = freq_array(:) / (eas.n_individuals * n_targets);

    frequency_weights = zeros(8,0);

    for i=1:8
        frequency_weights(i) = max(1, freq_array(i)*frequency_beta);
        
    end

end