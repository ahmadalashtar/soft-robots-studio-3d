% input: 
% - v1: a 3D vector as [x y z]
% - v2: a 3D vector as [x y z]
% output:
% - angles: the difference in angles to go from v2 to v1 as a rotation on x
% and rotation on y in respect to Z

function [rot_x, rot_y] = vectors2Angles(v1,v2)
    rot_x = calculateAngle([v1(3) v1(2)],[v2(3) v2(2)]);
    rot_y = calculateAngle([v1(3) v1(1)],[v2(3) v2(1)]);
end


% input: 
% - v1: a 2D vector on zx or zy
% - v2: a 2D vector on zx or zy
% output:
% - angle: the difference in angle to go from v2 to v1 in respect to the
% v1(1) and v2(1)

function angle = calculateAngle(v1,v2)
    
    x1 = v1(1);
    y1 = v1(2);
    x2 = v2(1);
    y2 = v2(2);
    v1n = norm(v1);
    v2n = norm(v2);
    
    if (x1 >= 0)
        v1angle = asind(y1/v1n);
    elseif (y1<=0)
        v1angle = asind(y1/v1n);
        v1angle = -180 - v1angle ;
    else
        v1angle = asind(y1/v1n);
        v1angle = 180 - v1angle ;
    end
    
    if (x2 >= 0)
        v2angle = asind(y2/v2n);
    elseif (y2<=0)
        v2angle = asind(y2/v2n);
        v2angle = -180 - v2angle ;
    else
        v2angle = asind(y2/v2n);
        v2angle = 180 - v2angle ;
    end
    
    angle = v1angle - v2angle;
    angle = round(angle,3);
end