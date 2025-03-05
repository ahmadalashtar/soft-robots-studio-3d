% Function to create and display the target on OptimizerAxes
function createTarget(app, x, y, z, xAngle, yAngle)
    % Check if coordinates and angles are valid (numbers)
    if any(isnan([x, y, z, xAngle, yAngle]))
        uialert(app.UIFigure, 'Please enter valid numeric coordinates and angles.', 'Input Error');
        return;
    end
    
    % Convert angles to radians (for trigonometric functions)
    xAngleRad = deg2rad(xAngle);
    yAngleRad = deg2rad(yAngle);

    % Now create a target icon on the OptimizerAxes
    hold(app.OptimizerAxes, 'on');  % Ensure that we add to existing plot

    % Create a simple scatter plot to represent the target (you can customize this)
    scatter3(app.OptimizerAxes, x, y, z, 100, 'filled', 'MarkerFaceColor', 'r');  % Red target marker
    
    % Apply rotation based on the input angles (simple example)
    % Here we assume angles are rotations around the X and Y axes
    % For example, rotate the target around the X and Y axes:
    rotMatrix = makeRotationMatrix(xAngleRad, yAngleRad);
    newCoords = rotMatrix * [x; y; z];
    
    % Plot the target with applied rotation (optional)
    scatter3(app.OptimizerAxes, newCoords(1), newCoords(2), newCoords(3), 100, 'filled', 'MarkerFaceColor', 'b');  % Blue rotated target
    
    % Optional: Add a label to the target
    text(app.OptimizerAxes, x, y, z, ' Target', 'FontSize', 12, 'Color', 'r');
    
    hold(app.OptimizerAxes, 'off');  % Turn off hold
end

% Helper function to create a rotation matrix for X and Y angles
function R = makeRotationMatrix(xAngle, yAngle)
    % Rotation matrix for X and Y axis
    Rx = [1, 0, 0; 
          0, cos(xAngle), -sin(xAngle); 
          0, sin(xAngle), cos(xAngle)];
      
    Ry = [cos(yAngle), 0, sin(yAngle); 
          0, 1, 0; 
          -sin(yAngle), 0, cos(yAngle)];
      
    % Combine rotations (Y then X)
    R = Rx * Ry;
end