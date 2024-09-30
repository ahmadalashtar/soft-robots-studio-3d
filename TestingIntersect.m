% 5. Overlapping Segments
    disp('Test 5: Overlapping Segments');
    segment1 = [1 2; 4 7];
    segment2 = [3 3; 5 5];
    result = intersection_func(segment1, segment2);
    disp(['Expected: (3, 3) to (4, 4), Got: ', mat2str(result)]);
    [intersect, point] = intersection_func(segment1, segment2);


    if intersect
        if isempty(point)
            disp('Segments overlap or are collinear.');
        else
            disp(['Lines intersect at point: (', num2str(point(1)), ', ', num2str(point(2)), ')']);
        end
    else
        disp('Lines do not intersect.');
    end