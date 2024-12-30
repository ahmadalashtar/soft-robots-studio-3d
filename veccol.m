% This function determines whether the vector collides with the cylindrical obstacle or not.

% Input:
% startPoint: A point in 3D space with 3 indices, being X, Y, Z. 
% It is the starting point of the vector (link) that ends with endPoint.
% endPoint: A point in 3D space with 3 indices, being X, Y, Z. 
% It is the ending point of the vector (link) that starts with startPoint.
% obstacle is a 5-index array representing a cylinder:
%   - First index: X position
%   - Second index: Y position
%   - Third index: Z position
%   - Fourth index: radius of the cylinder
%   - Fifth index: length (height) of the cylinder

% Output:
% isColliding: If the vector collides with the cylindrical obstacle or not.

function isColliding = veccol(startPoint, endPoint, obstacle)

    obstaclePos = obstacle(1:3);  %cylinder's position (center of base)
    radius = obstacle(4);         %cylinder's radius
    length = obstacle(5);         %cylinder's height

    cylinderTop = obstaclePos(3);             %top Z-coordinate of the cylinder
    cylinderBottom = cylinderTop - length;    %bottom Z-coordinate of the cylinder

    if (startPoint(3) < cylinderBottom && endPoint(3) < cylinderBottom) || ...
       (startPoint(3) > cylinderTop && endPoint(3) > cylinderTop)
        isColliding = false;
        return;
    end

    lineVector = endPoint - startPoint;
    trimmedStart = startPoint;
    trimmedEnd = endPoint;

    lineLength = norm(lineVector);

    if startPoint(3) < cylinderBottom
        t = (cylinderBottom - startPoint(3)) / lineVector(3);
        trimmedStart = startPoint + t * lineVector;
    elseif startPoint(3) > cylinderTop
        t = (cylinderTop - startPoint(3)) / lineVector(3);
        trimmedStart = startPoint + t * lineVector;
    end

    if endPoint(3) < cylinderBottom
        t = (cylinderBottom - trimmedStart(3)) / lineVector(3);
        trimmedEnd = trimmedStart + t * lineVector;
    elseif endPoint(3) > cylinderTop
        t = (cylinderTop - trimmedStart(3)) / lineVector(3);
        trimmedEnd = trimmedStart + t * lineVector;
    end

    [closest_x, closest_y] = closestPointOnSegment(trimmedStart(1), trimmedStart(2), trimmedEnd(1), trimmedEnd(2), obstaclePos(1), obstaclePos(2));

    distanceToCylinderBase = sqrt((closest_x - obstaclePos(1))^2 + (closest_y - obstaclePos(2))^2);

    isColliding = distanceToCylinderBase <= radius;

    %if isColliding
        %plotter(startPoint, endPoint, obstacle);
    %end
end


% Finds the closest point on a line segment to a given point in 2D space.

% Input:
% ax, ay - Coordinates of the segment's start point.
% bx, by - Coordinates of the segment's end point.
% px, py - Coordinates of the external point.

% Output:
% closest_x, closest_y - Coordinates of the closest point on the segment to (px, py).

function [closest_x, closest_y] = closestPointOnSegment(ax, ay, bx, by, px, py)
    abx = bx - ax;
    aby = by - ay;

    apx = px - ax;
    apy = py - ay;

    ab_ap_product = apx * abx + apy * aby;

    ab_magnitude_squared = abx^2 + aby^2;

    t = ab_ap_product / ab_magnitude_squared;

    t = max(0, min(1, t));

    closest_x = ax + t * abx;
    closest_y = ay + t * aby;
end


% Visualizes a 3D vector and its interaction with a cylindrical obstacle.

% Input:
% startPoint - A 3D point [X, Y, Z], representing the start of the vector.
% endPoint - A 3D point [X, Y, Z], representing the end of the vector.
% obstacle - A 5-element array representing a cylinder:
%              [X, Y, Z, radius, height], where (X, Y, Z) is the base center,
%              radius is the cylinder's radius, and height is its length.

% Output:
% A 3D plot visualizing the vector, its start and end points, and the cylindrical obstacle.

function plotter(startPoint, endPoint, obstacle)
    
    obstaclePos = obstacle(1:3);
    radius = obstacle(4);
    height = obstacle(5);
    
    cylinderTop = obstaclePos(3);
    cylinderBottom = cylinderTop - height;

    figure;
    hold on;
    grid on;

    scatter3(startPoint(1), startPoint(2), startPoint(3), 100, 'green', 'filled');
    scatter3(endPoint(1), endPoint(2), endPoint(3), 100, 'red', 'filled');

    plot3([startPoint(1), endPoint(1)], [startPoint(2), endPoint(2)], [startPoint(3), endPoint(3)], 'b', 'LineWidth', 2);

    [X, Y, Z] = cylinder(radius);
    Z = Z * height + cylinderBottom;

    X = X + obstaclePos(1);
    Y = Y + obstaclePos(2);
    
    surf(X, Y, Z, 'FaceAlpha', 0.3, 'EdgeColor', 'none');

    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Collision Check Visualization');
    axis equal;
    
    hold off;

end