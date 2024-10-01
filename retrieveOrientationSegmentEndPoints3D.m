function [end_points] = retrieveOrientationSegmentEndPoints3D()
    global op;
    
    
    end_points = zeros(size(op.targets,1),3);
    maxLength = 0;
    for i=1:size(op.targets,1)
        for j = 1:size(op.obstacles,1)
            target = op.targets(i,1:3);
            obstacle = op.obstacles(j,1:3);
            length = norm(obstacle-target);
            if length > maxLength
                maxLength = length;
            end
        end
    end
end



% u  = compute_unit_vector(op.targets(i,:));
%         segmentLength = norm(op.targets(i,1:3)-op.home_base(1:3))*1.25;
% 
%         p = op.targets(i,1:3) - u*segmentLength;
% 
% 
%         end_points(i,:) = p;