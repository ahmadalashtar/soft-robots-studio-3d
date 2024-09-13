function [end_points] = retrieveOrientationSegmentEndPoints3D(draw_plot)
    global op;
    
    
    end_points = zeros(size(op.targets,1),3);
    %segmentLength = op.n_links*op.length_domain(2);
    for i=1:1:size(op.targets,1)
        
            
        u  = compute_unit_vector(op.targets(i,:));
        % u  = segment2UnitVector(op.targets(i,:));
        
%         segmentLength = calculateSegmentLength(op.targets(i,:),angle,op.home_base,op.n_links*op.length_domain(2));
        segmentLength = norm(op.targets(i,1:3)-op.home_base(1:3))*1.25;
        
        p = op.targets(i,1:3) - u*segmentLength;
        
%         dO = [];
%         for j=1:1:size(op.obstacles,1)            
%             [op , inter] = intersectionSegmentCircle_2D([op.targets(i,1:2) ; p], op.obstacles(j,:), false);
%             if inter==true
%                 dO = [dO; norm(op-op.targets(i,1:2)),op];
%             end            
%         end
%         
%         if size(dO,1) > 0            
%             [m,ind] = min(dO(:,1));
%             p = dO(ind,2:3);
%         end
        % if draw_plot
        %     plot3([p(1),op.targets(i,1)],[p(2),op.targets(i,2)],[-p(3),-op.targets(i,3)],'--o','Color','r');
        % end
        end_points(i,:) = p;
        
    end
end

% function [length] = calculateSegmentLength(target,angle,home_base,max_length)
%     t = target(1:2);    
%     h = home_base(1:2);
% 
%     h=h-t;
%     angle = deg2rad(-angle);
%     r = [cos(angle) -sin(angle); sin(angle) cos(angle)];    
%     h = (r*h')';
% 
%     h(1) = round(h(1),3);
% 
%     if h(1)>0.0
%         length = h(1);
%     else
%         length = max_length;
%     end
% end