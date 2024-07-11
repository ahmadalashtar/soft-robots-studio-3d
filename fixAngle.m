% This fixes an angle.
% Makes sure that the angle is between 180 and -179, if not, I transform it in that range.
%
% INPUT:
% 'a' is the angle to be fixed (in degrees)
%
% OUTPUT:
% 'angle' is the fixed angle (in degrees)
function [angle] = fixAngle(a)
    angle = a;
    angle = angle - fix(angle/360)*360; % fix rounds the parameter to the nearest integer toward zero
    if angle==-180
        angle = 180;
    end
    if abs(angle)>180
        if angle>0
            angle = angle-360;
        else
            angle = 360+angle;
        end
    end
end