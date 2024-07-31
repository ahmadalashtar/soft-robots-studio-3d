classdef Chrom
    properties
        x
        y 
        fitness  
    end
    
    methods
        function obj = chrom(rotx,roty)
            obj.x = rotx;
            obj.y = roty;
        end
        function [fitness] = evaluate(obj,t_chrom,target_id)
            global op;
            rotx = obj.x;
            roty = obj.y;
            t_chrom(1,size(t_chrom,2)-2) = rotx;
            t_chrom(2,size(t_chrom,2)-2) = roty;
            conf = decodeIndividual(t_chrom);
            end_points = solveForwardKinematics3D(conf,op.home_base,false);
            ee_index = t_chrom(1,size(t_chrom,2)-3);
            fitness = norm(end_points(ee_index,:)-op.targets(target_id,:));
        end
     end
end
