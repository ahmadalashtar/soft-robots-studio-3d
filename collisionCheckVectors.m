function vectors = collisionCheckVectors(length, angleLimitPositiveX, angleLimitNegativeX, angleLimitPositiveY, angleLimitNegativeY)
    total_vectors = (angleLimitPositiveX + angleLimitNegativeX + 1) * (angleLimitPositiveY + angleLimitNegativeY + 1) * 4;
    vectors = zeros(total_vectors, 3);
    origin = zeros(total_vectors, 3);

    index = 1;

    for j = -angleLimitNegativeY:2:angleLimitPositiveY
        for i = -angleLimitNegativeX:2:angleLimitPositiveX

            angle_radX = deg2rad(i);
            angle_radY = deg2rad(j);

            unit_vector1 = [cos(angle_radX) * cos(angle_radY), sin(angle_radY), sin(angle_radX) * cos(angle_radY)];
            unit_vector2 = [cos(-angle_radX) * cos(angle_radY), sin(angle_radY), sin(-angle_radX) * cos(angle_radY)];
            unit_vector3 = [cos(angle_radX) * cos(-angle_radY), sin(-angle_radY), sin(angle_radX) * cos(-angle_radY)];
            unit_vector4 = [cos(-angle_radX) * cos(-angle_radY), sin(-angle_radY), sin(-angle_radX) * cos(-angle_radY)];

            vectors(index, :) = length * unit_vector1;
            vectors(index + 1, :) = length * unit_vector2;
            vectors(index + 2, :) = length * unit_vector3;
            vectors(index + 3, :) = length * unit_vector4;

            index = index + 4;
        end
    end

    figure;
    quiver3(origin(:,1), origin(:,2), origin(:,3), ...
            vectors(:,1), vectors(:,2), vectors(:,3), 0, 'r');

    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    title('3D Vectors XY');
    axis equal;
    grid on;
    view(3);
end