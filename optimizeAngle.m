function [angleX,angleY] = optimizeAngle(x, y)
    sum = abs(x)+abs(y);

    if sum > 180
        x = (abs(x)-180)*(x)/abs(x);
        y = -y+(180*abs(y)/y);
    end

    angleX = x;
    angleY = y;
end