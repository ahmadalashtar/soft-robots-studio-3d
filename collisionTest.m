function collisionTest()

segments = [ 
    0 0 15 ; 5 0 15  % from left afar
    0 0 15 ; 15 0 15  % from left touching
    0 0 15 ; 16 0 15  % from left a little inside

    30 0 15 ; 27 0 15  % from right afar
    30 0 15 ; 25 0 15  % from right touching
    30 0 15 ; 24 0 15  % from right a little inside

    20 0 20 ; 20 0 15  % from center
    14 0 20 ; 14 0 15  % vertical outside left
    15 0 20 ; 15 0 15  % vertical touching left 
    26 0 20 ; 14 0 15  % vertical outside right
    25 0 20 ; 15 0 15  % vertical touching right 
             ];

obstacle = [20 0 10 5 5];
timeScore = 0; % positive means veccol better negative means sxs better
totalVeccolTime = 0;
totalSxsTime = 0;
totalIterations = 0;
for i = 1 : 2 : size(segments,1)
    while segments(i,3)> -6
        totalIterations = totalIterations + 1;
        startPoint = segments(i,:);
        endPoint = segments(i+1,:);
        tic
        veccolResult = veccol(startPoint,endPoint,obstacle);
        veccolTime = toc;
        tic
        sxsResult = segmentxcylinder(startPoint,endPoint,obstacle);
        sxsTime = toc;
        totalVeccolTime = veccolTime;
        totalSxsTime = sxsTime;
        if sxsTime > veccolTime
            timeScore = timeScore +1;
        else
            timeScore = timeScore -1;
        end
        if veccolResult && ~sxsResult
            plotter(startPoint,endPoint,obstacle,"Veccol says there's + a collision, SXS says there's - no collision");
        elseif ~veccolResult && sxsResult
            plotter(startPoint,endPoint,obstacle,"Veccol says there's - no collision, SXS says there's + a collision");
        end
        segments(i,3) = segments(i,3)-1;
        segments(i+1,3) = segments(i+1,3)-1;
    end
end
result.timeScore = timeScore;
result.totalVeccolTime = totalVeccolTime;
result.totalSxsTime = totalSxsTime;
result.totalIterations = totalIterations;
disp(result);
end

function plotter(startPoint,endPoint,obstacle,Title)

    f = figure;
    hold on;
    axis equal;
    xlabel('x');
    ylabel('y'); 
    zlabel('z');
    f.CurrentAxes.ZDir = 'Reverse';
    f.CurrentAxes.XDir = 'Reverse';
    
    
    %draw op.obstacles

        [X,Y,Z] = cylinder(obstacle(4));
        X = X + obstacle(1);
        Y = Y + obstacle(2);
        Z = Z*-obstacle(5) + obstacle(3);
        plot3(X,Y,Z,'Color','k');
        th = 0:pi/50:2*pi;
        xunit = obstacle(4) * cos(th) + obstacle(1);
        yunit = obstacle(4) * sin(th) + obstacle(2);
        zunit = 0*th + obstacle(3);
        plot3(xunit, yunit, zunit,'Color','k');
        plot3(xunit, yunit, (zunit-obstacle(5)),'Color','k');
    
    %draw home
    plot3(0,0,0,'--gs','LineWidth',2,'MarkerSize',10,'MarkerEdgeColor','b');

    plot3([startPoint(1),endPoint(1)],[startPoint(2),endPoint(2)],[startPoint(3),endPoint(3)],'-o','Color','r');
            
    view(-159.1605,31.6712);
    title(num2str(Title));
end