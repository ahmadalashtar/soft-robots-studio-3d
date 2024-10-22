function [und] = calculateUndulation(chrom)

    global op;  % optimization problem
    global eas;  % genetic algorithm settings
    
    n_targets = size(op.targets,1);
    n_links = size(chrom,2) - eas.extra_genes;
    
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