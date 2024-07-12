function drawSegmentationArrow(end_points, targets, n, j)
    % Initial position
    endPosChange = end_points;

    dx = (targets(j,1) - end_points(j,1)) / n;
    dy = (targets(j,2) - end_points(j,2)) / n;
    dz = (targets(j,3) - end_points(j,3)) / n;

    for i = 1:n
        nextPos = endPosChange + [dx, dy, dz];

        plot3([endPosChange(j,1), nextPos(j,1)], [endPosChange(j,2), nextPos(j,2)], [endPosChange(j,3), nextPos(j,3)], "--b", "LineWidth", 1);

        segmentVec = [dx, dy, dz];
        unitV = segmentVec / norm(segmentVec);
        unitV = unitV * 25;

        angle = 30 * pi / 180;  %radian conversion
        rotMatXP = [1 0 0; 0 cos(angle) -sin(angle); 0 sin(angle) cos(angle)];
        rotMatXN = [1 0 0; 0 cos(-angle) -sin(-angle); 0 sin(-angle) cos(-angle)];
        rotMatYP = [cos(angle) 0 sin(angle); 0 1 0; -sin(angle) 0 cos(angle)];
        rotMatYN = [cos(-angle) 0 sin(-angle); 0 1 0; -sin(-angle) 0 cos(-angle)];
        rotMatZP = [cos(angle) -sin(angle) 0; sin(angle) cos(angle) 0; 0 0 1];
        rotMatZN = [cos(-angle) -sin(-angle) 0; sin(-angle) cos(-angle) 0; 0 0 1];
        
        pointXP = nextPos - (rotMatXP * unitV')';
        pointXN = nextPos - (rotMatXN * unitV')';
        point1P = nextPos - (rotMatYP * unitV')';
        point1N = nextPos - (rotMatYN * unitV')';
        point2P = nextPos - (rotMatZP * unitV')';
        point2N = nextPos - (rotMatZN * unitV')';

        %plotting arrow lines at 30 deg
        plot3([nextPos(j,1), pointXP(j,1)], [nextPos(j,2), pointXP(j,2)], [nextPos(j,3), pointXP(j,3)], "--r", "LineWidth", 1);
        plot3([nextPos(j,1), pointXN(j,1)], [nextPos(j,2), pointXN(j,2)], [nextPos(j,3), pointXN(j,3)], "--r", "LineWidth", 1);
        plot3([nextPos(j,1), point1P(j,1)], [nextPos(j,2), point1P(j,2)], [nextPos(j,3), point1P(j,3)], "--r", "LineWidth", 1);
        plot3([nextPos(j,1), point1N(j,1)], [nextPos(j,2), point1N(j,2)], [nextPos(j,3), point1N(j,3)], "--r", "LineWidth", 1);
        plot3([nextPos(j,1), point2P(j,1)], [nextPos(j,2), point2P(j,2)], [nextPos(j,3), point2P(j,3)], "--r", "LineWidth", 1);
        plot3([nextPos(j,1), point2N(j,1)], [nextPos(j,2), point2N(j,2)], [nextPos(j,3), point2N(j,3)], "--r", "LineWidth", 1);

        endPosChange = nextPos;
    end

end