function isColliding = veccol(startPoint, endPoint, obstacle)

    obstaclePos = obstacle(1:3);
    radius = obstacle(4);
    length = obstacle(5);

    cylinderTop = obstaclePos(3);
    cylinderBottom = cylinderTop - length;

    if (startPoint(3) < cylinderBottom && endPoint(3) < cylinderBottom) || (startPoint(3) > cylinderTop && endPoint(3) > cylinderTop)
        isColliding = false;
        return;
    end


    %checking if startPoint's or endPoint's x and y are within the cylinder's radius and z is within height range
    %UNNECESSARY.......
    % if (startPoint(1) < obstacle(1) + obstacle(4) && startPoint(1) > obstacle(1) - obstacle(4)) && (startPoint(2) < obstacle(2)+obstacle(4) && startPoint(2) > obstacle(2)-obstacle(4)) && (startPoint(3) > cylinderTop && startPoint(3) < cylinderBottom)
    %     isColliding = true;
    %     return;
    % end
    % if (endPoint(1) < obstacle(1) + obstacle(4) && endPoint(1) > obstacle(1) - obstacle(4)) && (endPoint(2) < obstacle(2)+obstacle(4) && endPoint(2) > obstacle(2)-obstacle(4)) && (endPoint(3) > cylinderTop && endPoint(3) < cylinderBottom)
    %     isColliding = true;
    %     return;
    % end

    %vector from startPoint to endPoint
    lineVector = endPoint - startPoint;
    lineLength = norm(lineVector);

    if lineLength == 0
        isColliding = false;
        return;
    end

    direction = lineVector / lineLength;

    if startPoint(3) < cylinderBottom
        tStart = (cylinderBottom - startPoint(3)) / lineVector(3);
        trimmedStart = startPoint + tStart * lineVector;
    else
        trimmedStart = startPoint;
    end

    if endPoint(3) > cylinderTop
        tEnd = (cylinderTop - startPoint(3)) / lineVector(3);
        trimmedEnd = startPoint + tEnd * lineVector;
    else
        trimmedEnd = endPoint;
    end

    %vector from startPoint to obstacles center.
    %this vector is 2 dimensional because we check the height separately
    %after.
    d = obstaclePos(1:2) - trimmedStart(1:2);

    %projecting the d vector to the line, then getting the closest point to
    %the obstacles center from that projection
    projLength = dot(d, direction(1:2));
    closestPointOnLine = trimmedStart + projLength * direction;

    %if projection is lower than the limit, startPoint is the closest
    %if projection is bigger than the limit, the endPoint is the closest
    if projLength < 0
        closestPointOnLine = trimmedStart;
    elseif projLength > lineLength
        closestPointOnLine = trimmedEnd;
    end

    %distance with closestPoint from cylinder.
    distanceToCylinderBase = norm(closestPointOnLine(1:2) - obstaclePos(1:2));

    %if the closest point is within the height range
    isWithinHeight = closestPointOnLine(3) >= cylinderBottom && closestPointOnLine(3) <= cylinderTop;

    %if it is within the height range, and the distance is smaller than the
    %radius, there is a collision
    isColliding = distanceToCylinderBase <= radius && isWithinHeight;

    %plotter()

    %upon closer look, we know if its inside the obstacle.
end

function plotter()

    startPoint = [2.1636, 2.175, 20.764];
    endPoint = [5.78466, 58.0723, 86.451];
    obstacle = [0 30 120 20 100];
    
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
    
    surf(X, Y, Z, 'FaceAlpha', 0.3, 'EdgeColor', 'none'); % Plot the cylinder with transparency

    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('Collision Check Visualization');
    axis equal;
    
    hold off;

end