% This function calculates the path vectors from a joint of the robot, which
% correlate to the link following that joint in the process of steering,
% ensuring the path does not collide with any obstacles.

% Input:
% p1: The starting point of the path (3D vector).
% p2: The midpoint of the path (3D vector).
% p3: The target endpoint of the path (3D vector).
% minLength: Minimum length to scale each path vector.
% obstacles: An array of obstacle positions to check for collisions.

% Output:
% col: A boolean value indicating if a collision occurs with any obstacle.

function [col] = pathVectors(p1, p2, p3, minLength, obstacles)
    pathVectorsArr = {};
    col = false;

    firstP = p2 - p1;
    firstP = firstP / norm(firstP);

    tarP = p3 - p2;
    tarP = tarP / norm(tarP);

    curP = firstP;
    K = cross(firstP, tarP, 1);
    K = K / norm(K);

    incrementAmount = 3;

    pathVectorsArr{1} = curP;
    pathVectorsArr{1} = minLength * pathVectorsArr{1} + p2;
    for j = 1:size(obstacles, 1)
        if veccol(p2, [pathVectorsArr{1}(1),pathVectorsArr{1}(2),pathVectorsArr{1}(3);], obstacles(j,:))
            col = true;
            return;
        end
    end
    index = 2;
    while acosd(dot(curP, firstP, 1)) + incrementAmount <= acosd(dot(firstP, tarP, 1))
        curP = rotateKAxis(curP, K, incrementAmount);
        pathVectorsArr{end + 1} = curP;
        pathVectorsArr{index} = minLength * pathVectorsArr{index} + p2;
        for j = 1:size(obstacles, 1)
            if veccol(p2, [pathVectorsArr{index}(1),pathVectorsArr{index}(2),pathVectorsArr{index}(3);], obstacles(j,:))
                col = true;
                return;
            end
        end
        index = index + 1;
    end
end

% This helper function rotates our vector (p) around an axis (K) by a given angle (theta).

% Input:
% p: The vector to be rotated (3D vector), it is a path vector in the process of steering.
% K: The axis of rotation (3D unit vector).
% theta: The angle of rotation in degrees.

% Output:
% rotP: The rotated vector (3D vector).

function rotP = rotateKAxis(p, K, theta)    
    Rk = [K(1)*K(1)*(1-cosd(theta)) + cosd(theta), K(1)*K(2)*(1-cosd(theta)) - (K(3)*sind(theta)), K(1)*K(3)*(1-cosd(theta)) + (K(2)*sind(theta));
    K(1)*K(2)*(1-cosd(theta)) + (K(3)*sind(theta)), K(2)*K(2)*(1-cosd(theta)) + cosd(theta), K(2)*K(3)*(1-cosd(theta)) - (K(1)*sind(theta));
    K(1)*K(3)*(1-cosd(theta)) - (K(2)*sind(theta)), K(2)*K(3)*(1-cosd(theta)) + (K(1)*sind(theta)), K(3)*K(3)*(1-cosd(theta)) + cosd(theta)];

    rotP = Rk * p;
end

% This function plots a 3D vector from an origin point to an endpoint.

% Input:
% org: The origin point of the vector (3D vector).
% p: The endpoint of the vector (3D vector).
% col: The color of the vector line.
% lineWidth: The thickness of the vector line (optional, default is 1.0).

function plotVector(org, p, col, lineWidth)
    arguments
        org
        p 
        col 
        lineWidth = 1.0
    end
    plot3([org(1); p(1)], [org(2); p(2)], [org(3); p(3)], color=col, LineWidth=lineWidth);
end