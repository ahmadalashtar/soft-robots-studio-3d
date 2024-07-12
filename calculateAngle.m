% input: 
% - v1: target's projection on zx or zy
% - v2: end point's vector projection on zx or zy
% output:
% - angle: the difference in angle to go from v2 to v1

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