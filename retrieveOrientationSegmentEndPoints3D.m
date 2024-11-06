function [endPoints] = retrieveOrientationSegmentEndPoints3D(targets,obstacles,base)

maxLength = retrieveMaxLength(targets,base);

n_targets = size(targets,1);

intersections(n_targets) = struct('Obstacles',[],'StopsAt',[]);
targetsUnitVectors = zeros(size(targets,1),3);
for i=1:n_targets
    startPoint = targets(i,1:3);
    u  = compute_unit_vector(targets(i,:));
    targetsUnitVectors(i,:) = u;
    endPoint = targets(i,1:3) - u*maxLength;
    for j = 1:size(obstacles,1)
        obstacle = obstacles(j,:);
        if segmentxcylinder(startPoint,endPoint,obstacle)
            intersections(i).Obstacles = [intersections(i).Obstacles j];
        end
    end
end
endPoints = targets(:,1:3) - targetsUnitVectors*maxLength;

for i = 1 : n_targets
    if isempty(intersections(i).Obstacles)
        continue;
    end
    obstacleIndices = intersections(i).Obstacles;
    intersections(i).StopsAt = nearestObstacleIDfromTarget(i,obstacleIndices,targets,obstacles);
    stopsAtObstacleIndex = intersections(i).StopsAt;
    target = targets(i,1:3);
    endPoint = endPoints(i,:);
    obstacle = obstacles(stopsAtObstacleIndex,:);
    endPoints(i,1:3) = retrieveCoordinates(target,endPoint,obstacle);
end

end

function coordinates = retrieveCoordinates(startPt,endPt,obstacle)
coordinates = endPt;
[inside,~,~] = segmentInsideCylinder(startPt,endPt,obstacle);
if inside
    coordinates = startPt;
    return;
end

radius = obstacle(4);
height= obstacle(5);

%YZ
obstacleX = obstacle(2);
obstacleY = obstacle(3);
startPoint = [startPt(2) startPt(3)];
endPoint = [endPt(2) endPt(3)];

lowerVertex1 = [obstacleX-radius, obstacleY];
lowerVertex2 = [obstacleX+radius, obstacleY];
upperVertex1 = [obstacleX-radius, obstacleY-height];
upperVertex2 = [obstacleX+radius, obstacleY-height];

%Vertical
[x1,y1] = polyxpoly([startPoint(1), endPoint(1)],[startPoint(2),endPoint(2)],...
    [lowerVertex1(1), upperVertex1(1)],[lowerVertex1(2), upperVertex1(2)]);
%Vertical
[x2, y2] = polyxpoly([startPoint(1), endPoint(1)],[startPoint(2),endPoint(2)],...
    [lowerVertex2(1), upperVertex2(1)],[lowerVertex2(2), upperVertex2(2)]);
%upper circle
[x3, y3] = polyxpoly([startPoint(1), endPoint(1)],[startPoint(2),endPoint(2)],...
    [upperVertex1(1), upperVertex2(1)],[upperVertex1(2), upperVertex2(2)]);
%lower circle
[x4, y4] = polyxpoly([startPoint(1), endPoint(1)],[startPoint(2),endPoint(2)],...
    [lowerVertex1(1), lowerVertex2(1)],[lowerVertex1(2), lowerVertex2(2)]);


%XZ
obstacleX = obstacle(1);
startPoint = [startPt(1) startPt(3)];
endPoint = [endPt(1) endPt(3)];

lowerVertex1 = [obstacleX-radius, obstacleY];
lowerVertex2 = [obstacleX+radius, obstacleY];
upperVertex1 = [obstacleX-radius, obstacleY-height];
upperVertex2 = [obstacleX+radius, obstacleY-height];

%Vertical
[x5,y5] = polyxpoly([startPoint(1), endPoint(1)],[startPoint(2),endPoint(2)],...
    [lowerVertex1(1), upperVertex1(1)],[lowerVertex1(2), upperVertex1(2)]);
%Vertical
[x6, y6] = polyxpoly([startPoint(1), endPoint(1)],[startPoint(2),endPoint(2)],...
    [lowerVertex2(1), upperVertex2(1)],[lowerVertex2(2), upperVertex2(2)]);
%upper circle
[x7, y7] = polyxpoly([startPoint(1), endPoint(1)],[startPoint(2),endPoint(2)],...
    [upperVertex1(1), upperVertex2(1)],[upperVertex1(2), upperVertex2(2)]);
%lower circle
[x8, y8] = polyxpoly([startPoint(1), endPoint(1)],[startPoint(2),endPoint(2)],...
    [lowerVertex1(1), lowerVertex2(1)],[lowerVertex1(2), lowerVertex2(2)]);

upperCircleIntersection = [];
lowerCircleIntersection = [];
% upper intersection?
length = Inf;
if ~isempty(x3) && ~isempty(x7)
    upperCircleIntersection = [x7(1) x3(1) y3(1)];
    if norm(upperCircleIntersection-startPt) < length
        coordinates = upperCircleIntersection;
        length = norm(upperCircleIntersection-startPt);
    end
end
if ~isempty(x4) && ~isempty(x8)
    lowerCircleIntersection = [x8(1) x4(1) y4(1)];
    if norm(lowerCircleIntersection-startPt) < length
        coordinates = lowerCircleIntersection;
        length = norm(lowerCircleIntersection-startPt);
    end
end

circlSegmentIntersections = segmentxcircle(startPt,endPt,[obstacle(1) obstacle(2) obstacle(4)]);
if ~isempty(circlSegmentIntersections)
    for i = 1 : size(circlSegmentIntersections,1)
        z = calculateZ(startPt,endPt,circlSegmentIntersections(i,:));
        if ~isempty(z)
            if ~pointToSegment3D([circlSegmentIntersections(i,:) z],startPt,endPt)
                coordinate = [circlSegmentIntersections(i,:) z];
                [result,~,~] = segmentInsideCylinder(coordinate,coordinate,obstacle);
                if result
                    if norm(coordinate-startPt) < length
                        coordinates = coordinate;
                        length = norm(coordinate-startPt);
                    end
                end
            end
        end
    end
end
%going through the circle above

%going through the circle below

%going throuh the sides
end

function coordinates = segmentxcircle(startPoint,endPoint,circle)
xSegment = [startPoint(1), endPoint(1)];  % x-coordinates of the line segment
ySegment = [startPoint(2), endPoint(2)];  % y-coordinates of the line segment

% Define the circle parameters
radius = circle(3);               % Radius of the circle
numPoints = 100;          % Number of points to approximate the circle

% Parametrize the circle as a polygon
theta = linspace(0, 2*pi, numPoints);
xCircle = circle(1) + radius * cos(theta);
yCircle = circle(2) + radius * sin(theta);

% Find intersection points between the line segment and the circle
[xInter, yInter] = polyxpoly(xSegment, ySegment, xCircle, yCircle);
coordinates = [xInter, yInter];
end

function nearestObstacleIndex = nearestObstacleIDfromTarget(targetIndex,obstacleIndices,targets,obstacles)
target = targets(targetIndex,:);
collisionObstacles = obstacles(obstacleIndices,:);

minLength = Inf;
for i = 1 : size(obstacleIndices,2)
    length  = norm(target(1:2)-collisionObstacles(i,1:2));
    if length < minLength
        minLength = length;
        nearestObstacleIndex  = obstacleIndices(i);
    end
end
end

function maxLength = retrieveMaxLength(targets,base)
maxLength = 0;
for i=1:size(targets,1)
    target = targets(i,1:3);
    length = norm(base(1:3)-target);
    if length > maxLength
        maxLength = length;
    end

end
maxLength = maxLength*2/3;
end