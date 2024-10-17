function [intersect, point] = intersection_func(seg1, seg2)
    
    % Extract coordinates from the segments
    x1_1 = seg1(1, 1); y1_1 = seg1(1, 2); % Start point of seg1
    x1_2 = seg1(2, 1); y1_2 = seg1(2, 2); % End point of seg1
    
    x2_1 = seg2(1, 1); y2_1 = seg2(1, 2); % Start point of seg2
    x2_2 = seg2(2, 1); y2_2 = seg2(2, 2); % End point of seg2
    
    % Calculate the direction vectors of the lines
    d1_x = x1_2 - x1_1;  % Direction vector of Line 1
    d1_y = y1_2 - y1_1;
    
    d2_x = x2_2 - x2_1;  % Direction vector of Line 2
    d2_y = y2_2 - y2_1;
    
    % Check if the lines are parallel by computing the determinant
    det = d1_x * d2_y - d1_y * d2_x;
    
    if det == 0
        % Lines are parallel, now check if they are collinear
        if (x2_1 - x1_1) * d1_y == (y2_1 - y1_1) * d1_x
            % The segments are collinear
            % Check for overlap by comparing the min and max bounds
            if max(x1_1, x1_2) >= min(x2_1, x2_2) && max(x2_1, x2_2) >= min(x1_1, x1_2) && ...
               max(y1_1, y1_2) >= min(y2_1, y2_2) && max(y2_1, y2_2) >= min(y1_1, y1_2)
                % The segments overlap
                intersect = true;
                point = []; % Multiple points of intersection
                return;
            else
                % Collinear but not overlapping
                intersect = false;
                point = [];
                return;
            end
        else
            % Lines are parallel but not collinear
            intersect = false;
            point = [];
            return;
        end
    end
    
    % Solve for t1 and t2 (parameters for the lines)
    t1 = ((x2_1 - x1_1) * d2_y - (y2_1 - y1_1) * d2_x) / det;
    t2 = ((x2_1 - x1_1) * d1_y - (y2_1 - y1_1) * d1_x) / det;
    
    % Check if the intersection occurs within the line segments
    if t1 >= 0 && t1 <= 1 && t2 >= 0 && t2 <= 1
        % Lines intersect within the segments
        intersect = true;
        % Calculate the intersection point
        point = [x1_1 + t1 * d1_x, y1_1 + t1 * d1_y];
    else
        % Intersection is outside the line segments
        intersect = false;
        point = [];
    end
end
