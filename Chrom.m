classdef Chrom
    properties
        x
        y 
        fitness  
    end
    
    methods
        function [fitness] = evaluate(obj,t_chrom,target_id)
            global op;
            t_chrom = getRobotChrom(obj,t_chrom);
            conf = decodeIndividual(t_chrom);
            end_points = solveForwardKinematics3D(conf,op.home_base,false);
            nodes_deployed = t_chrom(1,size(t_chrom,2)-1);
            target = op.targets(target_id,:);
            fitness = norm(end_points(nodes_deployed+1,:)-target(1:3));
        end
        function [robot_chrom] = getRobotChrom(obj,t_chrom)
            rotx = obj.x;
            roty = obj.y;
            t_chrom(1,size(t_chrom,2)-2) = rotx;
            t_chrom(2,size(t_chrom,2)-2) = roty;
            robot_chrom = t_chrom;
        end
     end
end
