%--------------STATIC PENALTY METHOD--------------
function [gScalar] = calculateStaticPenalty(chrom, r)          
    global op;  % optimization problem
    global eas; % genetic algorithm settings
    global algorithm;

    gScalar = 0;

    n_nodes = size(chrom,2) - gas.extra_genes;
    n_targets = size(op.targets,1);
    min_angle_x = op.angle_domain(1,2);
    max_angle_x = op.angle_domain(1,1);
    min_angle_y = op.angle_domain(2,2);
    max_angle_y = op.angle_domain(2,1);
    min_length = op.length_domain(1);

    for i = 1:2:n_targets*2
        final_angle_x = chrom(i,n_nodes+2);
        final_angle_y = chrom(i+1,n_nodes+2);
        last_link_length = chrom(i,n_nodes+4);

        g = zeros(1,8);     % array of penalty terms for each constraint
        beta = 1;           % parameter of penalty method

        %--CONSTRAINT 1,2: final angle is between angle bounds
        g(1) = abs(min(0,final_angle_x - min_angle_x))^beta;

        g(2) = abs(min(0,max_angle_x - final_angle_x))^beta;  

        g(3) = abs(min(0,final_angle_y - min_angle_y))^beta;

        g(4) = abs(min(0,max_angle_y - final_angle_y))^beta;    

        %--CONSTRAINT 3: final link length is > min link length, only if there is only 1 link on the target's orientation segment
        linksOnSegment = chrom(i,n_nodes+3) - (chrom(i,n_nodes+1)-1);
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
                
        if collisionCheck(conf,op)
            intersections = intersections + 1;
        end

        g(6) = intersections;

        %--CONSTRAINT 5: final angle is between angle bounds

        % this constraint is needed in beacause of the algorithm of distance point-segment,
        % since it can generate the closest point to be one of the edges of the segment, 
        % and in case that point is the target then the solution would be horrible
        
        link_count= chrom(i,n_nodes+1)-1;
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
            switch algorithm
                case 'ga'
                    gas.infeasible_subcount = gas.infeasible_subcount+intersections;
                case 'bbbc'
                    bbbcs.infeasible_subcount = bbbcs.infeasible_subcount+intersections;
            end
           % --- running variance by https://lingpipe-blog.com/2009/07/07/welford-s-algorithm-delete-online-mean-variance-deviation/
%            gas.infeasible_running_stats(2) = gas.infeasible_running_stats(2)+1;
%            nextM = gas.infeasible_running_stats(1) + (intersections - gas.infeasible_running_stats(1)) / gas.infeasible_running_stats(2);
%            gas.infeasible_running_stats(3) = gas.infeasible_running_stats(3) + (intersections - gas.infeasible_running_stats(1)) * (intersections - nextM);
%            gas.infeasible_running_stats(1) = nextM;

        end
        
        gScalar = gScalar + g*r';
    end
end
