% calculates undulation 'zigzag' in the chrom
%   it takes projections on the xz and yz planes for each link 
%   and checks for angle sign change
function [und] = calculateUndulation(chrom)
    global op;
    global eas;  % genetic algorithm settings
    

    n_links = size(chrom,2) - eas.extra_genes;
    configurations = decodeIndividual(chrom);

    undulations = zeros(1,size(configurations,3));

    for i = 1 : size(configurations,3)
        row = i*2-1;
        conf = configurations(:,:,i);
        nodes = solveForwardKinematics3D(conf,op.home_base,0);
        epsilon = chrom(row, n_links + 1);
        nNodes = size(nodes,1);
        nNodesToCheck = min(epsilon + 1,nNodes);
        if nNodesToCheck < 4
            continue;
        end
        signsX = zeros(1,nNodesToCheck-2);
        signsY = zeros(1,nNodesToCheck-2);
        for j = 1 : nNodesToCheck-2
            point1 = nodes(j,:);
            point2 = nodes(j+1,:);
            point3 = nodes(j+2,:);
            vector1 = point2-point1;
            vector2 = point3-point2;

            signsX(j) = getRotationSign(vector1(2:3),vector2(2:3));
            % reversed so that it's calculated the same, to understand
            % this, darw the rotation axes on a paper.
            signsY(j) = getRotationSign([vector1(3) vector1(1)],[vector2(3) vector2(1)]);
        end

        % check if the first sign is positive, negative, or zero
        for j = 1:size(signsX,2)-1
            if signsX(j) ~= signsX(j+1) 
                undulations(i) = undulations(i) + 1;
            end
        end
        for j = 1:size(signsY,2)-1
            if signsY(j) ~= signsY(j+1) 
                undulations(i) = undulations(i) + 1;
            end
        end
        undulations(i) = undulations(i) / 2;
        undulations(i) = undulations(i) / (nNodesToCheck-3);
    end
    und = mean2(undulations);
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
    

    angle1 = atan2d(y1,x1);
    angle2 = atan2d(y2,x2);
    
    difference = angle1 - angle2;
    if ~difference
        sign = 0;
    else
        sign = (abs(difference)/difference);
    end
end