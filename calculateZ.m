function z = calculateZ(A, B, pointXY)
    % A: 1x3 vector representing point A [x1, y1, z1]
    % B: 1x3 vector representing point B [x2, y2, z2]
    % pointXY: 1x2 vector representing the point [x, y]

    % Extract coordinates from input
    x1 = A(1);
    y1 = A(2);
    z1 = A(3);
    
    x2 = B(1);
    y2 = B(2);
    z2 = B(3);
    
    x = pointXY(1);
    y = pointXY(2);
    
    % Calculate the direction vector components
    dx = x2 - x1;
    dy = y2 - y1;
    dz = z2 - z1;
    
    % Solve for t using the x and y equations
    if dx ~= 0
        t_x = (x - x1) / dx;
    else
        t_x = NaN; % Assign NaN if the line is vertical in x
    end
    
    if dy ~= 0
        t_y = (y - y1) / dy;
    else
        t_y = NaN; % Assign NaN if the line is vertical in y
    end
    
    % Check if t_x and t_y yield the same t
    if isnan(t_x) && isnan(t_y)
        z = [];
        return;
    elseif isnan(t_x)
        t = t_y;
    elseif isnan(t_y)
        t = t_x;
    else
        if abs(t_x - t_y) > 1e-6
            z = [];
            return;
        end
        t = t_x; % or t_y, both should be equal
    end
    
    % Calculate the z coordinate
    z = z1 + dz * t;
end