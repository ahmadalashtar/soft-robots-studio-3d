%--------------STATIC PENALTY METHOD--------------
function [gScalar] = calculateStaticPenalty(chrom, r)          
    global op;  % optimization problem
    global eas; % genetic algorithm settings

    gScalar = 0;

    n_links = size(chrom,2) - eas.extra_genes;
    n_targets = size(op.targets,1);
    min_angle_x = op.angle_domain(1);
    max_angle_x = op.angle_domain(2);
    min_angle_y = op.angle_domain(1);
    max_angle_y = op.angle_domain(2);
    min_length = op.length_domain(1);

    for i = 1:2:n_targets*2
        final_angle_x = chrom(i,n_links+2);
        final_angle_y = chrom(i+1,n_links+2);
        last_link_length = chrom(i,n_links+4);

        g = zeros(1,9);     % array of penalty terms for each constraint
        beta = 1;           % parameter of penalty method

        %--CONSTRAINT 1,2: final angle is between angle bounds
        g(1) = abs(min(0,final_angle_x - min_angle_x))^beta;

        g(2) = abs(min(0,max_angle_x - final_angle_x))^beta;  

        g(3) = abs(min(0,final_angle_y - min_angle_y))^beta;

        g(4) = abs(min(0,max_angle_y - final_angle_y))^beta;    

        %--CONSTRAINT 3: final link length is > min link length, only if there is only 1 link on the target's orientation segment
        linksOnSegment = chrom(i,n_links+3) - (chrom(i,n_links+1)-1);
        if linksOnSegment <= 1
            g(5) = abs(min(0,last_link_length - min_length))^beta;
        else
            g(5) = 0;
        end

        %--CONSTRAINT 4: no collision with obstacles
        intersections = 0;  % counter for the intersections
        configurations = decodeIndividual(chrom); 
        conf = configurations(:,:,ceil(i/2));
        % check intersections for every segment of each configuration of the robot
                
        nodes = solveForwardKinematics3D(conf,op.home_base,0);

        intersections = intersections + collisionCheck(conf);

        g(6) = intersections;

        %--CONSTRAINT 5: final angle is between angle bounds

        % this constraint is needed in beacause of the algorithm of distance point-segment,
        % since it can generate the closest point to be one of the edges of the segment, 
        % and in case that point is the target then the solution would be horrible
        
        link_count= chrom(i,n_links+1)-1;
        sum_of_angles_x = sum(chrom(i,1:link_count)) + final_angle_x;
        sum_of_angles_y = sum(chrom(i+1,1:link_count)) + final_angle_y;
        target_angle_x= op.targets(ceil(i/2),4) - op.home_base(4);
        target_angle_y= op.targets(ceil(i/2),5) - op.home_base(5);
        angle_range_x= [target_angle_x-10 target_angle_x+10];
        angle_range_y= [target_angle_y-10 target_angle_y+10];
        if(sum_of_angles_x<min(angle_range_x) || sum_of_angles_x>max(angle_range_x))
            g(7)=1;
        end
        if(sum_of_angles_y<min(angle_range_y) || sum_of_angles_y>max(angle_range_y))
            g(8)=1;
        end

     

        if(g(6) ~= 0)
            eas.infeasible_subcount = eas.infeasible_subcount+intersections;

           % --- running variance by https://lingpipe-blog.com/2009/07/07/welford-s-algorithm-delete-online-mean-variance-deviation/
%            gas.infeasible_running_stats(2) = gas.infeasible_running_stats(2)+1;
%            nextM = gas.infeasible_running_stats(1) + (intersections - gas.infeasible_running_stats(1)) / gas.infeasible_running_stats(2);
%            gas.infeasible_running_stats(3) = gas.infeasible_running_stats(3) + (intersections - gas.infeasible_running_stats(1)) * (intersections - nextM);
%            gas.infeasible_running_stats(1) = nextM;

        end

        nUsedLinks = 0;
        for i = 1:size(conf,1)
            if conf(i,3)==0
                nUsedLinks = i-1;
                break;
            end
        end
        nUsedNodes = nUsedLinks + 1;

        for i = 1:1:nUsedNodes - 1

            angle_X = atand(abs(nodes(i+1, 1) - nodes(i, 1))/abs(nodes(i+1, 3) - nodes(i, 3)));
            angle_Y = atand(abs(nodes(i+1, 2) - nodes(i, 2))/abs(nodes(i+1, 3) - nodes(i, 3)));
            prevAngle_X = atand(abs(nodes(i,1) - nodes(i-1,1))/abs(nodes(i,3) - nodes(i-1,3)));
            prevAngle_Y = atand(abs(nodes(i,2) - nodes(i-1,2))/abs(nodes(i,3) - nodes(i - 1,3)));

            vectors = collisionCheckVectors(op.length_domain(1), angle_X, angle_Y, nodes(i,:), prevAngle_X, prevAngle_Y);
            
            if vectorObstacleCheck(vectors, op.obstacles, nodes(i,:))
                g(9) = g(9) + 1;
            end
        end
            
        gScalar = gScalar + g*r';
    end
end
