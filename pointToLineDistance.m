function [result] = pointToLineDistance(point,linePoint1,linePoint2)

    pointToLinePoint1 = distance_between_two_points(point,linePoint1);
    pointToLinePoint2 = distance_between_two_points(point,linePoint2);
    lineLength = distance_between_two_points(linePoint1,linePoint2);
    
    angle1 = calculateAngle(pointToLinePoint2, lineLength, pointToLinePoint1);
    angle2 = calculateAngle(pointToLinePoint1,pointToLinePoint2,lineLength);
    % angle = calculateAngle(lineLength, pointToLinePoint1,pointToLinePoint2);


    if (angle1 >= 90 || angle2 >= 90)
        result = min(pointToLinePoint1,pointToLinePoint2);
    else
        result = calculateHeight(pointToLinePoint2,angle2);
    end
    
end

function [distance] = distance_between_two_points(point1,point2)
    % https://www.cuemath.com/geometry/distance-between-two-points/
    % PQ = d = √ [(x2 – x1)2 + (y2 – y1)2 + (z2 – z1)2].
    distance = sqrt((point2(:,1)-point1(:,1))^2 + (point2(:,2)-point1(:,2))^2 + (point2(:,3)-point1(:,3))^2);
end

function [angle] = calculateAngle(a, b, c)
%{

    .   
  .   .
 a      c
.... b....

    cos α = [b2 + c2 – a2]/2bc
    cos β = [a2 + c2 – b2]/2ac
    cos γ = [b2 + a2 – c2]/2ab
    
    calculates the angle between b and c
%}

    angle = acosd((b^2 + c^2 - a^2)/(2*b*c));


end

function height = calculateHeight(hypot,angle)
    height = hypot*sind(angle);
end
