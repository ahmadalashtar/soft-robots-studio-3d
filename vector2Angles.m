function [ x, y, z ] = vector2Angles(vector)    
    coordinates = vector;
    zx = [coordinates(3) coordinates(1)];
    zy = [coordinates(3) coordinates(2)];
    x = fixAngle(rad2deg(atan(zy(2)/zy(1))));
    y = fixAngle(rad2deg(atan(zx(2)/zx(1))));
    if isnan(x)
        x=0;
    end
    if isnan(y)
        y=0;
    end

    z = 0;
end