function vectors = collisionCheckVectors(minLength, targetAngleX, targetAngleY, startPoint)

    % if targetAngleX > angleLimitPositiveX || targetAngleX < angleLimitNegativeX
    %     disp("Target X angle should be within bounds")
    %     return;
    % end
    % 
    % if targetAngleY > angleLimitPositiveY || targetAngleY < angleLimitNegativeY
    %     disp("Target Y angle should be within bounds")
    %     return;
    % end

    index = 1;

    vectors = zeros(ceil((targetAngleY / 2 + 1) * (targetAngleX / 2 + 1)), 3); 
    
    XincrementAmount = 2;
    YincrementAmount = 2;

    if targetAngleX < 0
        XincrementAmount = XincrementAmount * -1;
    end
    if targetAngleY < 0
        YincrementAmount = YincrementAmount * -1;
    end

    for j = 0:XincrementAmount:targetAngleY
        for i = 0:YincrementAmount:targetAngleX

            angle_radX = deg2rad(i);
            angle_radY = deg2rad(j);

            unit_vector1 = [cos(angle_radX) * cos(angle_radY), sin(angle_radY), sin(angle_radX) * cos(angle_radY)];
            
            vectors(index, :) = startPoint + (minLength * unit_vector1);

            % y_value = sin(angle_radY);
            % if isKey(grouped_vectors, y_value)
            %     grouped_vectors(y_value) = [grouped_vectors(y_value); vectors(index:index+3, :)];
            % else
            %     grouped_vectors(y_value) = vectors(index:index+3, :);
            % end

            index = index + 1;
        end
    end

    vectors = vectors(1:index-1, :);

    % origin = zeros(index - 1, 3);
    % figure;
    % quiver3(origin(:,1), origin(:,2), origin(:,3), ...
    %         vectors(:,1), vectors(:,2), vectors(:,3), 0, 'r');
    % 
    % xlabel('X');
    % ylabel('Y');
    % zlabel('Z');
    % title('3D Vectors XY');
    % axis equal;
    % grid on;
    % view(3);

end