function pathVectorsArr = pathVectors(p1, p2, p3, minLength)
    pathVectorsArr = {};

    firstP = p2 - p1;
    firstP = firstP / norm(firstP);

    tarP = p3 - p2;
    tarP = tarP / norm(tarP);

    curP = firstP;
    K = cross(firstP, tarP, 1);
    K = K / norm(K);

        % hold on;
    % 
    % axis equal;
    % 
    % limMin = -1;
    % limMax = 1;
    % 
    % xlabel('X');
    % ylabel('Y');
    % zlabel('Z');
    % xlim([limMin, limMax]);
    % ylim([limMin, limMax]);
    % zlim([limMin, limMax]);
    % 
    % plotVector([1; 0; 0], 'k');
    % plotVector([0; 1; 0], 'k');
    % plotVector([0; 0; 1], 'k');
    % 
    % plotVector(firstP, 'b', 5);
    % plotVector(tarP, 'r', 5);
    % plotVector(K, 'c', 5)

    incrementAmount = 3;

    pathVectorsArr{1} = curP;
    while acosd(dot(curP, firstP, 1)) + incrementAmount <= acosd(dot(firstP, tarP, 1))
        curP = rotateKAxis(curP, K, incrementAmount);
        pathVectorsArr{end + 1} = curP; 
    end

    for i = 1:size(pathVectorsArr, 2)
        pathVectorsArr{i} = minLength * pathVectorsArr{i} + p2;
        plotVector(p2, pathVectorsArr{i}, 'g');
    end
end


function rotP = rotateKAxis(p, K, theta)    
    Rk = [K(1)*K(1)*(1-cosd(theta)) + cosd(theta), K(1)*K(2)*(1-cosd(theta)) - (K(3)*sind(theta)), K(1)*K(3)*(1-cosd(theta)) + (K(2)*sind(theta));
    K(1)*K(2)*(1-cosd(theta)) + (K(3)*sind(theta)), K(2)*K(2)*(1-cosd(theta)) + cosd(theta), K(2)*K(3)*(1-cosd(theta)) - (K(1)*sind(theta));
    K(1)*K(3)*(1-cosd(theta)) - (K(2)*sind(theta)), K(2)*K(3)*(1-cosd(theta)) + (K(1)*sind(theta)), K(3)*K(3)*(1-cosd(theta)) + cosd(theta)];

    rotP = Rk * p;
end

function rotP = rotateXYPrime(p, rotX, rotY)
    rotX = deg2rad(rotX);
    rotY = deg2rad(rotY);

    Rx = [1, 0, 0; 0, cos(rotX), -sin(rotX); 0, sin(rotX), cos(rotX)];
    Ry = [cos(rotY), 0, sin(rotY); 0, 0, 0; -sin(rotY), 0, cos(rotY)];

    rotP = Rx * Ry * p;
end

function plotVector(org, p, col, lineWidth)
    arguments
        org
        p 
        col 
        lineWidth = 1.0
    end
    plot3([org(1); p(1)], [org(2); p(2)], [org(3); p(3)], color=col, LineWidth=lineWidth);
end