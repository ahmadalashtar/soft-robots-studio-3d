function [ u ] = angles2UnitVector(target,end_point)  
    global op;
    u = (target(1:3)-end_point(1:3))/norm(target(1:3)-end_point(1:3));
end