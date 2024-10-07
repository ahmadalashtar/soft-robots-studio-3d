function [ellipseCoords, h] = ellipseMaker( rx,ry,x0,y0,z0,Nb,pitch,roll,yaw,graph,C )
%% Definition
%
% Ellipse3D generates a three row, single column vector that holds the
% coordinates of an ellipse in 3D space and can optionally plot it.
%
% Generation of the ellipse coordinates occurs via the following
% methodology:
%
%   1. Plot an ellipse on the XY plane with semimajor axis of radius rx
%      along X axis and semimajor axis of radius ry along Y axis
%
%   2. Rotate ellipse CCW about X axis by 'pitch' radians. 0 leaves ellipse
%      on XY plane. pi/2 rotates CCW about positive X-axis and puts ellipse
%      on XZ plane
%
%   3. Rotate ellipse CCW about Y axis by 'roll' radians. 0 leaves
%      ellipse on XY plane. pi/2 rotates CCW about positive Y-axis and puts
%      ellipse on YZ plane
%
%   4. Rotate ellipse CCW about Z axis by 'yaw'
%      radians. 0 leaves ellipse on XY plane. pi/2 rotates CCW about
%      positive Z-axis and (leaving ellipse on XY plane)
%
%   5. Apply offsets of x0, y0, and z0 to ellipse
%
%   6. Optionally generate 3D plot of ellipse
%
%% Inputs
%
% rx - length of radius of semimajor axis of ellipse along x-axis
% ry - length of radius of semimajor axis of ellipse along y-axis
% x0 - origin of ellipse with respect to x-axis
% y0 - origin of ellipse with respect to y-axis
% z0 - origin of ellipse with respect to z-axis
% Nb - number of points used to define ellipse
% pitch - angle of pitch in radians of ellipse wRt +x-axis
% roll - angle of roll in radians of ellipse wRt +y-axis
% yaw - angle of yaw in radians of ellipse wRt +z-axis
% graph - flag that tells function whether or not to graph.
%   0 - do not graph
%   1 - graph and let this function define graphing options
%   >1 - graph, but allow other functions to define graphing options
% C - color of ellipse to be plotted. Acceptable input either in character
%   form ('r') or RGB form ([0 .5 1])
%
%% Outputs
%
% ellipseCoords - holds coordinates of ellipse in form:
% [ X
%   Y
%   Z ]
% h - graphics handle of ellipse if graphed, 0 otherwise
%% Usage Examples
% ELLIPSE(rx,ry,x0,y0,z0) adds an on the XY plane ellipse with semimajor
% axis of rx, a semimajor axis of radius ry centered at the point x0,y0,z0.
%
% ELLIPSE(rx,ry,x0,y0,z0,Nb), Nb specifies the number of points
% used to draw the ellipse. The default value is 300. Nb may be used
% for each ellipse individually.
%
% ELLIPSE(rx,ry,x0,y0,z0,Nb, pitch,roll,yaw) adds an on the XY plane 
% ellipse with semimajor axis of rx, a semimajor axis of radius ry centered
% at the point x0,y0,z0 and a pose in 3D space defined by roll, pitch, and
% yaw angles
%
% as a sample of how ellipse works, the following produces a red ellipse
% tipped up with a pitch of 45 degrees
% [coords, h] = ellipse3D(1,2,0,0,0,300,pi/4,0,0,1,'r');
%
% note that if rx=ry, ELLIPSE3D plots a circle
%% Mathematical Formulation
% Declare angle vector theta (t in parametric equation of ellipse)
the=linspace(0,2*pi,Nb);
% Create X and Y vectors using parametric equation of ellipse
X=rx*cos(the);
Y=ry*sin(the);
% Declare the Z plane as all zeros before transformation
Z=zeros(1, length(X));
% Define rotation matrix about X axis. 0 leaves ellipse on XY plane. pi/2
% rotates CCW about X-axis and puts ellipse on XZ plane
Rpitch = [1          0           0          ;...
          0          cos(pitch)  -sin(pitch);...
          0          sin(pitch)  cos(pitch)];
% Define rotation matrix about Y axis. 0 leaves ellipse on XY plane. pi/2
% rotates CCW about Y-axis and puts ellipse on YZ plane
Rroll = [cos(roll)   0   sin(roll)  ;...
         0           1   0          ;...
         -sin(roll)  0   cos(roll)] ;
% Define rotation matrix about about Z axis. 0 leaves ellipse on XY plane. 
% pi/2 rotates CCW about Z-axis and (leaving ellipse on XY plane)
Ryaw = [cos(yaw)   -sin(yaw)  0;...
        sin(yaw)   cos(yaw)   0;...
        0           0         1];
% Apply transformation
for i=1:length(X)
    
    xyzMat = [X(i);Y(i);Z(i)]; % create temp values
    temp = Rpitch*xyzMat; % apply pitch
    temp = Rroll*temp; % apply roll
    temp = Ryaw*temp; % apply yaw
    X(i) = temp(1); % store results
    Y(i) = temp(2);
    Z(i) = temp(3);
    
end
% Apply offsets
X = X + x0;
Y = Y + y0;
Z = Z + z0;
%% Graphing
if graph > 0
    
    if graph == 1
        axis equal;
        axis auto;
        axis vis3d;
        grid on;
        view(3);
        
        axisLength = max([rx ry]) + max([abs(x0) abs(y0) abs(z0)]);
        h3=line([0,axisLength],[0,0],[0,0]);
        set(h3,'Color','b');
        text(axisLength,0,0,'X');
        
        h2=line([0,0],[0,axisLength],[0,0]);
        set(h2,'Color','g');
        text(0,axisLength,0,'Y');
        
        h1=line([0,0],[0,0],[0,axisLength]);
        set(h1,'Color','r');
        text(0,0,axisLength,'Z');
        
        h = line(X,Y,Z); % plot ellipse in 3D
        set(h,'color',C); % Set color of ellipse
    else
    
        h = line(X,Y,Z); % plot ellipse in 3D
        set(h,'color',C); % Set color of ellipse
    end
    
end
ellipseCoords = [X;Y;Z]; % define return values
end