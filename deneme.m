function deneme()
    % Create a figure and 3D plot
    figure;
    [X, Y] = meshgrid(-10:0.5:10, -10:0.5:10);
    Z = sin(sqrt(X.^2 + Y.^2));
    
    % Create a 3D surface plot
    surf(X, Y, Z);
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('3D Plot with Static-like Line');
    
    % Hold the plot for further drawing
    hold on;
    
    % Initial 3D coordinates for the line
    hLine = plot3([-10 10], [0 0], [0 0], 'r', 'LineWidth', 2);
    rotate3d on;
    
    % Initial camera position
    camPos = get(gca, 'CameraPosition');
    
    % Rotation loop
    while ishandle(hLine)  % Continue until the line is deleted
        % Rotate the camera
        camPos(1) = 20 * cosd(0);
        camPos(2) = 20 * sind(0);
        
        % Update the line position to maintain static appearance
        updateStaticLine(gca, hLine);
        
        % Pause for a short duration to visualize the rotation
        pause(0.05); % Adjust the pause duration for speed
    end
end

% Function to update the line to maintain static appearance
function updateStaticLine(ax, hLine)
    % Get the current camera position and target
    camPos = get(ax, 'CameraPosition');
    camTarget = get(ax, 'CameraTarget');
    camUp = get(ax, 'CameraUpVector');
    
    % Calculate the direction vector from the camera to the target
    camDir = camTarget - camPos;
    camDir = camDir / norm(camDir); % Normalize direction vector
    
    % Calculate the right vector (perpendicular to camera direction and up vector)
    camRight = cross(camDir, camUp);
    camRight = camRight / norm(camRight); % Normalize
    
    % Define the length of the line
    lineLength = 10;
    
    % Compute new 3D positions for the line to keep it visually static
    newLineX = camRight(1) * [-1 1] * lineLength;
    newLineY = camRight(2) * [-1 1] * lineLength;
    newLineZ = camRight(3) * [-1 1] * lineLength;
    
    % Update the 3D line's coordinates to maintain its "static" appearance
    set(hLine, 'XData', newLineX, 'YData', newLineY, 'ZData', newLineZ);
end