%--------------MODIFIED RANDOM MUTATION--------------

function [chrom] = modifiedRandomMutation(chrom)
    global op;  % optimization problem
    global gas; % genetic algorithm settings
    targets= size(chrom,1)-1;
    ll_index = targets+1;
    bounds_angle= op.angle_domain;
    bounds_length= op.length_domain;
    a=0.5;
    angle=0;
    
    max_perturbation= (bounds_length(2) - bounds_length(1))/2;
    for j=1:1:op.n_nodes
        
        chrom(ll_index,j) = chrom(ll_index,j) + (rand-a)*max_perturbation;
        chrom(ll_index,j) = max(min(bounds_length(2),chrom(ll_index,j)),bounds_length(1));
        
    end

    max_perturbation= (bounds_angle(2)-bounds_angle(1))/2;
    
    for i=1: 1:targets
        end_effector = op.home_base(1:3);
        robot_orientation = [1 0];

        for j=1: 1: op.n_nodes
            if j==1
                if op.first_angle.is_fixed==false
                    angle_bound= [chrom(i,j)-(max_perturbation/2) chrom(i,j)+(max_perturbation/2)] ;
                    angle=getRandomAngleAvoidingObastacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.obstacles, angle_bound, false);
                    angle=max(min(bounds_angle(2),angle),bounds_angle(1));
                    chrom(i,j)=angle;
%                    chrom(i,j)=op.first_angle.angle;% don't mutate
                else
                    chrom(i,j)=op.first_angle.angle;
                end
            else
                if(gas.obstacle_avoidance== false)
                    chrom(i,j)= chrom(i,j) + (rand-a)*max_perturbation;
                    chrom(i,j) = max(min(bounds_angle(2),chrom(i,j)),bounds_angle(1));
                else
                    angle_bound= [chrom(i,j)-(max_perturbation/2) chrom(i,j)+(max_perturbation/2)] ;
                    angle=getRandomAngleAvoidingObastacles(end_effector, robot_orientation, chrom(ll_index,j), bounds_length, op.obstacles, angle_bound, false);
                    angle=max(min(bounds_angle(2),angle),bounds_angle(1));
                    chrom(i,j)=angle;
                end
            end
            %------------Forward Kinematics--------------
            alpha = deg2rad(angle);
            new_end_effector = end_effector+robot_orientation*(chrom(ll_index,j));
            new_end_effector = [(new_end_effector(1)-end_effector(1))*cos(alpha) - (new_end_effector(2)-end_effector(2))*sin(alpha) , (new_end_effector(1)-end_effector(1))*sin(alpha) + (new_end_effector(2)-end_effector(2))*cos(alpha)]+end_effector;   
            robot_orientation = (new_end_effector-end_effector)/norm(new_end_effector-end_effector);
            end_effector = new_end_effector;
            %--------------------------------------------
        end
    end
    
end