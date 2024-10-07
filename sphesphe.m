function [xout, yout, zout] = sphesphe(x1, y1, z1, r1, x2, y2, z2, r2)
    %circcirc but for spheres in 3D space
    
    assert(isscalar(x1) && isscalar(y1) && isscalar(z1) && isscalar(r1) && ...
           isscalar(x2) && isscalar(y2) && isscalar(z2) && isscalar(r2), ...
        'Inputs must be scalars')
    
    assert(isreal([x1, y1, z1, r1, x2, y2, z2, r2]), 'Inputs must be real')
    
    assert(r1 > 0 && r2 > 0, 'Radius must be positive')
    
    d = sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2);
    
    if d > r1 + r2 || d < abs(r1 - r2) || d == 0 && r1 == r2
        xout = NaN;
        yout = NaN;
        zout = NaN;
        return;
    end
    
    a = (r1^2 - r2^2 + d^2) / (2 * d);
    
    xc = x1 + (a / d) * (x2 - x1);
    yc = y1 + (a / d) * (y2 - y1);
    zc = z1 + (a / d) * (z2 - z1);
    
    h = sqrt(r1^2 - a^2);
    
    ex = (x2 - x1) / d;
    ey = (y2 - y1) / d;
    ez = (z2 - z1) / d;
    
    if abs(ex) > abs(ey)
        p = [-ey, ex, 0];
    else
        p = [0, -ez, ey];
    end
    p = p / norm(p);
    
    q = cross([ex, ey, ez], p); 
    
    xout = [xc + h * p(1), xc - h * p(1)];
    yout = [yc + h * p(2), yc - h * p(2)];
    zout = [zc + h * p(3), zc - h * p(3)];

end