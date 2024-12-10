% Calculate the fitness of a chromosome/individual
% Objective functions are: 
% (1) minimize the distance from the end effector to the target
% (2) minimize the displacement between the orientation of the end effector and the target desired orientation of reaching
% (3) minimize the number of links used to reach the target
% All these objective functions can be modeled into a single objective function. 
% The main idea is, istead of reaching the target, we simply want to reach the target's orientation segment; 
% then we would cut the remaining part of the chromosome (which will be unused, i.e. not everted from the robot).
% By minimizing the summation of all the distances between the used nodes of the robot and the target's orientation segment, 
% we are including all the three objective functions in a single one.
% It also makes sense to increase the importance of the distance from the as the number of used nodes increases 
% (i.e., we want to get closer to the segment).
% Therefore, the distances are wrapped together in a weighted sum, with
% weights that linearly increase with the index of the associated node 
% (we do not consider node 1 because the container of the robot does not move).
%
% To avoid robots that "zigzag" around the target's orientation segment, we "cut" the robot by using two search algorithms: 
% - hill climbing  (the first node that gets locally closer to the segment)
% - first link that intersects the target's orientation segment
% and we cut at the minimum between the nodes retreived by these two strategies.
%
% INPUT:
% 'chrom' is the chromosome [t*2+1 x n+4] to be evaluated (extra genes
% should be empty) %%EMİR modified it to +4
% 'draw_plot' is a boolean flag, true if you want to plot the segments from targets
%
% OUTPUT:
% 'chrom' is the evaluated chromosome [t*2+1 x n+4] with added information in the extra genes%%EMİR modified it to +4
% 'fitness' a scalar numeric value representing the fitness of the chromosome
function [chrom, fitness] = calculateFitness3D(chrom, draw_plot)
    arguments
        chrom;
        draw_plot = 0;
    end
    
    global op;  % optimization problem
    global eas;  % genetic algorithm settings
    
    % the chromosome will be evaluated in this function
    % if it has been previoulsy evaluated, its extra genes would be different than 0
    % this would corrupt the chromosome during evaluation
    % therefore, reset the last extra genes to zero, and restart the evaluation
    chrom(:,op.n_links+1:op.n_links+eas.extra_genes) = 0; 
    
    fitness = [0 0 0 0 0];
    sumLinks = 0;
    sumLinksOnSegment = 0;
    totLength = 0;
    
    n_targets = size(op.targets,1);
    n_links = op.n_links;
    
    if draw_plot
        configurations = decodeIndividual(chrom); 
        drawProblem3D(configurations);
    end
    
    for i=1:2:n_targets*2
        ceili2 = ceil(i/2);
        t = op.targets(ceili2,:);
        thisConf_totLength = 0;

        configurations = decodeIndividual(chrom);
        conf = configurations(:,:,ceili2);        
        
        %----CALCULATE MIN DISTANCE FROM ROBOT TO TARGET'S ORIENTATION SEGMENT AND LAST ANGLE
        robot_points = solveForwardKinematics3D(conf,op.home_base,false);
        [dist_mat, ee_index] = calculateMinDistance_FromOrientationSegment(robot_points,[op.targets(ceili2,1:3);op.end_points(ceili2,:)]);
        chrom(i,n_links+1) = ee_index;  % this is the index of the closest node to the target's orientation segment
        chrom(i+1,n_links+1) = ee_index;  % this is the index of the closest node to the target's orientation segment
        chrom(i,n_links+3) = op.n_links;  % this is the index of the closest node to the target's orientation segment
        chrom(i+1,n_links+3) = op.n_links;  % this is the index of the closest node to the target's orientation segment
        sumLinks = sumLinks + chrom(i,n_links+1)-1;
        
        if draw_plot==true
            for j = 1:1:ee_index
                n_proj = dist_mat(j,2:3);
                plot([robot_points(j,1),n_proj(1)],[robot_points(j,2),n_proj(2)],'--o','Color','k'); 
            end 
        end

        fit = dist_mat(ee_index);        
        fitness(1) = fitness(1) + fit;

        ee_link_index = ee_index -1 ;
        [final_angle_x, final_angle_y] = solveInverseKinematics3D(conf,robot_points,ee_link_index,op.targets(ceili2,1:3));
        [final_angle_x, final_angle_y] = optimizeAngle(final_angle_x, final_angle_y);
        % end
        chrom(i,n_links+2) = final_angle_x;   % thixs is the angle to align the robot to the target's orientation segment
        chrom(i+1,n_links+2) = final_angle_y;   % thixs is the angle to align the robot to the target's orientation segment
        
         %----CUT ROBOT
        configurations = decodeIndividual(chrom); 
        conf = configurations(:,:,ceili2);
        robot_points = solveForwardKinematics3D(conf,op.home_base,false);
        ee_point = robot_points(ee_index, :);
        dist2target = norm(ee_point-t(1:3));
        for j=ee_index:1:n_links
            l = chrom(n_targets*2+1,j);
            if(dist2target<l)
                %cut here
                lastNode_index = j;
                chrom(i,n_links+3) = lastNode_index;
                chrom(i,n_links+4) = dist2target; %cut length
                chrom(i+1,n_links+3) = lastNode_index;
                chrom(i+1,n_links+4) = dist2target; %cut length
                sumLinksOnSegment = sumLinksOnSegment + chrom(i,n_links+3) - chrom(i,n_links+1) + 1;%%EMİR i didn't touch this
                break;
            end
            dist2target = dist2target - l;
        end
        
        %----calculate robot total length
        for j=1:1:chrom(i,n_links+3)-1
            thisConf_totLength = thisConf_totLength + chrom(n_targets*2+1,j);
        end
        thisConf_totLength = thisConf_totLength + chrom(i,n_links+4);
        totLength = max(thisConf_totLength,totLength);
    end
    
    fitness(1) = fitness(1) / n_targets;  % normalize the fitness among number of targets/configurations
    fitness(2) = sumLinks; % / n_targets;
    fitness(3) = round(calculateUndulation(chrom) * 100);    % already normalized
    fitness(4) = sumLinksOnSegment; %/ n_targets;   
    fitness(5) = totLength;
    if draw_plot==true
        configurations = decodeIndividual(chrom); 
        drawProblem2D(configurations);
    end
end

% Calculate which node is closer to the target's orientation segmet (uses Voronoi distance defined in "Stroppa, F., Loconsole, C., & Frisoli, A. (2018). Convex polygon fitting in robot-based neurorehabilitation. Applied Soft Computing, 68, 609-625")
% Return a [? x 3] matrix where each row is:
% - distance from the node (at relative index) to the target's orientation segment
% - x coordinate of the robot's node Voronoi projecton on the segment orientation)
% - y coordinate of the robot's node Voronoi projecton on the segment orientation)
% Also, return the index of the last node before the cut
function [dist_mat, ee_index] = calculateMinDistance_FromOrientationSegment(robot_points,target_segment)
    % robot_points = [ 0 0 0;
    %                  0.5 0.5 0;
    %                  2 2 0;
    %                  4 3 0];
    % target_segment = [1 1 0; 3 1 0];
    dist_mat = zeros(size(robot_points,1)-1,1);
    % min_dist = 0;
    % min_rowIndex = 2;
    
    % start from 2 so do not consider the first node (the robot's container cannot move!)
    for j = 1 : size(robot_points,1)            
        [d, ~, ~] = pointToSegment3D(robot_points(j,:),target_segment(1,:),target_segment(2,:));
        dist_mat(j,1) = d;
        % dist_mat(j,2) = ee_proj(1);
        % dist_mat(j,3) = ee_proj(2);
        
        %---------------------------------------------------------------            
    end
    
    dist_mat(:,1) = abs(dist_mat(:,1)); % go back to having distances all positive (euclidean distances are positive!)
    
    [~,ee_index] = min(dist_mat(:,1));
    if ee_index == 1    
        ee_index = 2;   % in case the closest point turns out to be the robot base, go one further; this configuration is going to be probably infeasible due to the last angle anyways
    end
    dist_mat = dist_mat(1:ee_index,:);  % cut all nodes after the minimum (it means the robot will not stop grow in that direction from now on)
end