function [undulations] = calculateUndulation(chrom)
    global op;
    global eas;  % genetic algorithm settings

    n_links = size(chrom,2) - eas.extra_genes;
    configurations = decodeIndividual(chrom);

    undulations = 0;

    for i = 1 : size(configurations,3)
        conf = configurations(:,:,i);
        nodes = solveForwardKinematics3D(conf,op.home_base,0);
        lastNode = chrom(i*2-1, n_links + 1);
        
        if lastNode > 2
            signsX = zeros(1,lastNode-2);
            signsY = zeros(1,lastNode-2);
            for j = 1 : lastNode-3
                point1 = nodes(j,:);
                point2 = nodes(j+1,:);
                point3 = nodes(j+2,:);
                vector1 = point2-point1;
                vector2 = point3-point2;

                % normalize
                vector1 = vector1/norm(vector1);
                vector2 = vector2/norm(vector2);

                signsX(j) = getRotationSign(vector1(2:3),vector2(2:3));
                % reversed so that it's calculated the same, to understand
                % this, darw the rotation axes on a paper.
                signsY(j) = getRotationSign([vector1(3) vector1(1)],[vector1(3) vector1(1)]);
            end

            % check if the first sign is positive, negative, or zero
            for j = 1:size(signs,2)-1
                if signs(j)~=signs(j+1) 
                    undulations = undulations + 1;
                end
            end
        end
    end

end

% 2D vectors, could be [z x] and could be [y z]
% sign is +, -, or 0
function [sign] = getRotationSign(vector1,vector2)
    % coordinate axis has 4 parts, upper right, upper left, lower right,
    % lower left
    
    x1 = vector1(1);
    x2 = vector2(1);
    y1 = vector1(2);
    y2 = vector2(2);
    

    % first case: no change
    if y1 == y2 && x1 == x2
        sign = 0;
        return;
    end

    angle1 = atan2(x1,y1);
    angle2 = atan2(x2,y2);
    
    difference = angle1 - angle2;
    sign = (difference/difference)*(-1);
end




    
    
    
    changes_x = zeros(n_targets,1);       % count changes in direction 
    changes_y = zeros(n_targets,1);       % count changes in direction
    
    % count changes in direction for each configuration
    for i = 1:2:n_targets*2
        ceili2 = ceil(i/2);
        lastNode = chrom(i, n_links + 1);                 % get last node
        angleSigns_x = chrom(i,1:lastNode);               % get angles until cut
        angleSigns_y = chrom(i+1,1:lastNode);             % get angles until cut
        angleSigns_x(lastNode) = chrom(i,n_links + 2);    % replace last angle
        angleSigns_y(lastNode) = chrom(i+1,n_links + 3);    % replace last angle
        angleSigns_x = sign(angleSigns_x);                % get signs of angles
        angleSigns_y = sign(angleSigns_y);                % get signs of angles
        angleSigns_x = angleSigns_x(angleSigns_x~=0);     % remove any zeros from angles (love this matlab function)
        angleSigns_y = angleSigns_y(angleSigns_y~=0);     % remove any zeros from angles (love this matlab function)
        for j = 2:size(angleSigns_x,2)
            if angleSigns_x(j) ~= angleSigns_x(j-1)
                changes_x(ceili2) = changes_x(ceili2) + 1;
            end
        end
        for j = 2:size(angleSigns_y,2)
            if angleSigns_y(j) ~= angleSigns_y(j-1)
                changes_y(ceili2) = changes_y(ceili2) + 1;
            end
        end
        changes_x(ceili2) = changes_x(ceili2) / lastNode;             % normalize on the number of nodes
        changes_y(ceili2) = changes_y(ceili2) / lastNode;             % normalize on the number of nodes
    end
    und_x = mean(changes_x);
    und_y = mean(changes_y);
    und = (und_x + und_y)/2;
end