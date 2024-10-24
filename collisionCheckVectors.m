function vectors = collisionCheckVectors(minLength, targetAngleX, targetAngleY, startPoint, currentAngleX, currentAngleY)

    % if targetAngleX > angleLimitPositiveX || targetAngleX < angleLimitNegativeX
    %     disp("Target X angle should be within bounds")
    %     return;
    % end
    % 
    % if targetAngleY > angleLimitPositiveY || targetAngleY < angleLimitNegativeY
    %     disp("Target Y angle should be within bounds")
    %     return;
    % end

    index = 1;

    vectors = zeros(ceil((targetAngleY / 2 + 1) * (targetAngleX / 2 + 1)), 3); 
    
    XincrementAmount = 1;
    YincrementAmount = 1;

    if targetAngleX < currentAngleX
        XincrementAmount = XincrementAmount * -1;
    end
    if targetAngleY < currentAngleY
        YincrementAmount = YincrementAmount * -1;
    end


    for i = currentAngleX:XincrementAmount:targetAngleX

        angle_radX = deg2rad(i);
        
        unit_vector1 = [1, 0, 0; 0, cos(angle_radX), -sin(angle_radX); 0, sin(angle_radX), cos(angle_radX)];

        new_unitVector = unit_vector1;
        tcp_coords = (new_unitVector * [0 0 minLength]')';
        newCoords = tcp_coords + startPoint;
        
        vectors(index, :) = newCoords;

        % y_value = sin(angle_radY);
        % if isKey(grouped_vectors, y_value)
        %     grouped_vectors(y_value) = [grouped_vectors(y_value); vectors(index:index+3, :)];
        % else
        %     grouped_vectors(y_value) = vectors(index:index+3, :);
        % end

        index = index + 1;
    end
    for j = currentAngleY:YincrementAmount:targetAngleY
        angle_radY = deg2rad(j);

        unit_vector2 = [cos(angle_radY), 0, sin(angle_radY); 0, 1, 0; -sin(angle_radY), 0, cos(angle_radY)];

        new_unitVector = unit_vector1 * unit_vector2;
        tcp_coords = (new_unitVector * [0 0 minLength]')';
        newCoords = tcp_coords + startPoint;

        vectors(index, :) = newCoords;

        index = index + 1;
    end

    vectors = vectors(1:index-1, :);

    startPoints = repmat(startPoint, size(vectors, 1), 1);
    
    hold on;

    for i = 1:size(vectors, 1)
        plot3([startPoints(i,1), vectors(i,1)], ...
              [startPoints(i,2), vectors(i,2)], ...
              [startPoints(i,3), vectors(i,3)], 'g');
    end

    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('3D Vectors XY');
    axis equal;
    grid on;
    view(3);

end

function rotP = rotateXYPrime(p, rotX, rotY)
    rotX = deg2rad(rotX);
    rotY = deg2rad(rotY);

    Rx = [1, 0, 0; 0, cos(rotX), -sin(rotX); 0, sin(rotX), cos(rotX)];
    Ry = [cos(rotY), 0, sin(rotY); 0, 0, 0; -sin(rotY), 0, cos(rotY)];

    rotP = Rx * Ry * p;
end

function plotVector(p, col, lineWidth)
    arguments
        p 
        col 
        lineWidth = 1.0
    end
    plot3([0; p(1)], [0; p(2)], [0; p(3)], color=col, LineWidth=lineWidth);
end

function omercase()

    currentAngleX = 0;
    currentAngleY = 0;
    targetAngleX = 90;
    targetAngleY = 90;
    pathPoints = {rotateXYPrime([0; 0; 1], currentAngleX, currentAngleY), ... 
        rotateXYPrime([0; 0; 1], targetAngleX, targetAngleY)};
    hold on;

    axis equal;

    limMin = -1;
    limMax = 1;

    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    xlim([limMin, limMax]);
    ylim([limMin, limMax]);
    zlim([limMin, limMax]);

    plotVector([1; 0; 0], 'k');
    plotVector([0; 1; 0], 'k');
    plotVector([0; 0; 1], 'k');

    plotVector(pathPoints{1}, 'b', 5);
    plotVector(pathPoints{2}, 'r', 5);

    incrementAmount = 1;

    currentAngleX = min(currentAngleX, targetAngleX);
    targetAngleX = max(currentAngleX, targetAngleX);

    currentAngleY = min(currentAngleY, targetAngleY);
    targetAngleY = max(currentAngleY, targetAngleY);


    while currentAngleX < targetAngleX
        if currentAngleY < targetAngleY
            currentAngleY = currentAngleY + incrementAmount;
        end

        currentAngleX = currentAngleX + incrementAmount;
        plotVector(rotateXYPrime([0; 0; 1], currentAngleX, currentAngleY), 'g');
    end

    while currentAngleY < targetAngleY
        currentAngleY = currentAngleY + incrementAmount;
        plotVector(rotateXYPrime([0; 0; 1], currentAngleX, currentAngleY), 'g');
    end
end