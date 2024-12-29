%optimizes two angles x and y
% gives back two angles that reach the same point but with less movement
function [angleX,angleY] = optimizeAngle(x, y)
    sum = abs(x)+abs(y);

    if sum > 180
        x = (abs(x)-180)*(x)/abs(x);
        y = -y+(180*abs(y)/y);
    end

    angleX = x;
    angleY = y;
end