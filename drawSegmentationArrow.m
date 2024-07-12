function drawSegmentationArrow(end_points, targets, n)
    % Initial position
    endPosChange = end_points;

    dx = (targets(1,1) - end_points(1,1)) / n;
    dy = (targets(1,2) - end_points(1,2)) / n;
    dz = (targets(1,3) - end_points(1,3)) / n;

    for i = 1:n
        nextPos = endPosChange + [dx, dy, dz];

        plot3([endPosChange(1,1), nextPos(1,1)], [endPosChange(1,2), nextPos(1,2)], [endPosChange(1,3), nextPos(1,3)], "--b", "LineWidth", 1);

        segmentVec = [dx, dy, dz];
        unitV = segmentVec / norm(segmentVec);
        unitV = unitV * 25;

        angle = 30 * pi / 180;  %radian conversion
        rotMatYP = [cos(angle) 0 sin(angle); 0 1 0; -sin(angle) 0 cos(angle)];
        rotMatYN = [cos(-angle) 0 sin(-angle); 0 1 0; -sin(-angle) 0 cos(-angle)];
        rotMatZP = [cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1];
        rotMatZN = [cos(-angle) -sin(-angle) 0; sin(-angle) cos(-angle) 0; 0 0 1];

        point1P = nextPos - (rotMatYP * unitV')';
        point1N = nextPos - (rotMatYN * unitV')';
        point2P = nextPos - (rotMatZP * unitV')';
        point2N = nextPos - (rotMatZN * unitV')';

        %plotting arrow lines at 30 deg
        plot3([nextPos(1,1), point1P(1,1)], [nextPos(1,2), point1P(1,2)], [nextPos(1,3), point1P(1,3)], "--r", "LineWidth", 1);
        plot3([nextPos(1,1), point1N(1,1)], [nextPos(1,2), point1N(1,2)], [nextPos(1,3), point1N(1,3)], "--r", "LineWidth", 1);
        plot3([nextPos(1,1), point2P(1,1)], [nextPos(1,2), point2P(1,2)], [nextPos(1,3), point2P(1,3)], "--r", "LineWidth", 1);
        plot3([nextPos(1,1), point2N(1,1)], [nextPos(1,2), point2N(1,2)], [nextPos(1,3), point2N(1,3)], "--r", "LineWidth", 1);

        endPosChange = nextPos;
    end

end