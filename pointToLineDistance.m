function [result] = pointToLineDistance(point,linePoint1,linePoint2)

    pointToLinePoint1 = distance_between_two_points(point,linePoint1);
    pointToLinePoint2 = distance_between_two_points(point,linePoint2);
    lineLength = distance_between_two_points(linePoint1,linePoint2);
    
    if (lineLength == 0 || pointToLinePoint1 == 0 || pointToLinePoint2 == 0)
        result = min(pointToLinePoint1,pointToLinePoint2);
        return;
    end

    angle1 = calculateAngle(pointToLinePoint2, lineLength, pointToLinePoint1);
    angle2 = calculateAngle(pointToLinePoint1,pointToLinePoint2,lineLength);


    if (angle1 >= 90 || angle2 >= 90)
        result = min(pointToLinePoint1,pointToLinePoint2);
    else
        result = calculateHeight(pointToLinePoint2,angle2);
    end
    
end

function [distance] = distance_between_two_points(point1,point2)
    distance = sqrt((point2(:,1)-point1(:,1))^2 + (point2(:,2)-point1(:,2))^2 + (point2(:,3)-point1(:,3))^2);
end

function [angle] = calculateAngle(a, b, c)
    angle = acosd((b^2 + c^2 - a^2)/(2*b*c));
end

function height = calculateHeight(hypot,angle)
    height = hypot*sind(angle);
end
