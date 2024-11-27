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
        targetIndex = ceil(i/2);
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
                
        [nodes] = solveForwardKinematics3D(conf,op.home_base,0);

        intersections = intersections + collisionCheck(nodes, op.obstacles, chrom(i, end-1));

        g(6) = intersections;

        %--CONSTRAINT 5: final angle is between angle bounds

        % this constraint is needed in beacause of the algorithm of distance point-segment,
        % since it can generate the closest point to be one of the edges of the segment, 
        % and in case that point is the target then the solution would be horrible

     

        if(g(6) ~= 0)
            eas.infeasible_subcount = eas.infeasible_subcount+intersections;

           % --- running variance by https://lingpipe-blog.com/2009/07/07/welford-s-algorithm-delete-online-mean-variance-deviation/
%            gas.infeasible_running_stats(2) = gas.infeasible_running_stats(2)+1;
%            nextM = gas.infeasible_running_stats(1) + (intersections - gas.infeasible_running_stats(1)) / gas.infeasible_running_stats(2);
%            gas.infeasible_running_stats(3) = gas.infeasible_running_stats(3) + (intersections - gas.infeasible_running_stats(1)) * (intersections - nextM);
%            gas.infeasible_running_stats(1) = nextM;

        end

        % what if the epsilon node was directly on the target? Enter
        % Constraint #7

        % get the coordinates of the target and its endpoint
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
        
        % if the result is NaN then the epsilon is exactly on the target.
        % Penalize
        if isnan(angle)
            g(7) = 1;
        % else if the angle is larger or equal to 90, penalize.
        elseif angle >= 90
            g(7) = 1;
        else
            g(7)=0;
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
                 g(9) = g(9) + 1;
                 break;
            end
        end

        gScalar = gScalar + g*r';
    end
end
