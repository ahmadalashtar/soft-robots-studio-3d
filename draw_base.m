function ps = draw_base(app, x, y, z, angle, axes)
    % Draws a 3D rectangle (prism) based on given position (x, y, z) and angle
    % Returns the plot object
    
    theta = angle * pi / 180;  % Convert angle to radians
    H = 3;                     % Height of the rectangle (fixed)
    L = 3;                     % Length of the rectangle (fixed)
    
    % Center location
    center_location = [x, y, z];
    center1 = center_location(1);  % X-coordinate
    center2 = center_location(2);  % Y-coordinate
    center3 = center_location(3);  % Z-coordinate
    
    % 2D rotation matrix for the X-Y plane (Z is fixed)
    R = [cos(theta), -sin(theta); sin(theta), cos(theta)];
    
    % Define the base 2D coordinates (for the XY-plane at Z = 0)
    X = [-L/2, L/2, L/2, -L/2];  % X coordinates of the square
    Y = [-H/2, -H/2, H/2, H/2];  % Y coordinates of the square
    
    % Apply the rotation to the 2D square
    T = zeros(2, 4);
    for i = 1:4
        T(:, i) = R * [X(i); Y(i)];
    end
    
    % Get the transformed coordinates for the bottom face
    x_lower_left = center1 + T(1, 1);
    x_lower_right = center1 + T(1, 2);
    x_upper_right = center1 + T(1, 3);
    x_upper_left = center1 + T(1, 4);
    
    y_lower_left = center2 + T(2, 1);
    y_lower_right = center2 + T(2, 2);
    y_upper_right = center2 + T(2, 3);
    y_upper_left = center2 + T(2, 4);
    
    % Define the coordinates of the bottom face (in 3D)
    x_coor = [x_upper_left, x_lower_left, x_lower_right, x_upper_right];
    y_coor = [y_upper_left, y_lower_left, y_lower_right, y_upper_right];
    z_coor = [center3, center3, center3, center3];  % Z coordinates of the bottom face
    
    % Define the top face coordinates (Z = center3 + H)
    z_top = center3 + H;
    x_coor_top = [x_upper_left, x_lower_left, x_lower_right, x_upper_right];
    y_coor_top = [y_upper_left, y_lower_left, y_lower_right, y_upper_right];
    z_coor_top = [z_top, z_top, z_top, z_top];
    
    % Create the bottom face of the rectangle (prism)
    bottom_face = [x_coor; y_coor; z_coor];
    
    % Create the top face of the rectangle (prism)
    top_face = [x_coor_top; y_coor_top; z_coor_top];
    
    % Plot the bottom face using patch
    ps = patch('Vertices', [bottom_face(1,:)' bottom_face(2,:)' bottom_face(3,:)'], ...
               'Faces', [1,2,3,4], ...
               'FaceColor', [0, 0, 1], ...  % RGB for blue
               'FaceAlpha', 1, 'EdgeColor', 'k');  % Edge color black
    
    % Plot the top face using patch
    hold(axes, 'on');
    patch('Vertices', [top_face(1,:)' top_face(2,:)' top_face(3,:)'], ...
          'Faces', [1,2,3,4], ...
          'FaceColor', [0, 0, 1], ...  % RGB for blue
          'FaceAlpha', 1, 'EdgeColor', 'k');  % Edge color black
    
    % Plot the vertical sides (edges) using patch
    for i = 1:4
        % Create the side faces (4 vertical faces)
        side_face = [ ...
            [bottom_face(1,i), bottom_face(1, mod(i,4)+1)]; ...
            [bottom_face(2,i), bottom_face(2, mod(i,4)+1)]; ...
            [bottom_face(3,i), top_face(3, mod(i,4)+1)]];
        
        patch('Vertices', side_face', 'Faces', [1,2,3,4], ...
              'FaceColor', [0, 0, 1], ...  % RGB for blue
              'FaceAlpha', 1, 'EdgeColor', 'k');  % Edge color black
    end
    
    hold(axes, 'off');
end
