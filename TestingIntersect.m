% Testing normal and edge cases for segment intersection
    disp('=== Testing Normal Cases ===');

    % 1. Intersecting Segments (Standard Case)
    disp('Test 1: Intersecting Segments');
    segment1 = [0 0; 4 4];
    segment2 = [0 4; 4 0];
    result = intersection_func(segment1, segment2);
    disp(['Expected: (2, 2), Got: ', mat2str(result)]);

    % 2. Non-Intersecting Parallel Segments
    disp('Test 2: Non-Intersecting Parallel Segments');
    segment1 = [0 0; 4 0];
    segment2 = [0 2; 4 2];
    result = intersection_func(segment1, segment2);
    disp(['Expected: No intersection, Got: ', mat2str(result)]);

    % 3. Non-Parallel, Non-Intersecting Segments
    disp('Test 3: Non-Parallel, Non-Intersecting Segments');
    segment1 = [0 0; 2 2];
    segment2 = [3 1; 5 0];
    result = intersection_func(segment1, segment2);
    disp(['Expected: No intersection, Got: ', mat2str(result)]);

    % 4. Touching at an Endpoint (Intersection at Endpoint)
    disp('Test 4: Touching at an Endpoint');
    segment1 = [0 0; 4 4];
    segment2 = [4 4; 5 5];
    result = intersection_func(segment1, segment2);
    disp(['Expected: (4, 4), Got: ', mat2str(result)]);

    % 5. Overlapping Segments
    disp('Test 5: Overlapping Segments');
    segment1 = [1 1; 4 4];
    segment2 = [3 3; 5 5];
    result = intersection_func(segment1, segment2);
    disp(['Expected: (3, 3) to (4, 4), Got: ', mat2str(result)]);

    % 6. Contained Segment (Full Overlap)
    disp('Test 6: Contained Segment (Full Overlap)');
    segment1 = [1 1; 5 5];
    segment2 = [2 2; 4 4];
    result = intersection_func(segment1, segment2);
    disp(['Expected: (2, 2) to (4, 4), Got: ', mat2str(result)]);

    disp('=== Testing Edge Cases ===');

    % 7. Coincident but Non-Overlapping (Collinear, but Disjoint)
    disp('Test 7: Coincident but Non-Overlapping');
    segment1 = [1 1; 2 2];
    segment2 = [3 3; 4 4];
    result = intersection_func(segment1, segment2);
    disp(['Expected: No intersection, Got: ', mat2str(result)]);

    % 8. Point as a Segment (Degenerate Case)
    disp('Test 8a: Point as a Segment, intersection');
    segment1 = [2 2; 2 2]; % Point
    segment2 = [1 1; 3 3];
    result = intersection_func(segment1, segment2);
    disp(['Expected: (2, 2), Got: ', mat2str(result)]);

    disp('Test 8b: Point as a Segment, no intersection');
    segment1 = [1 1; 1 1]; % Point
    segment2 = [2 2; 3 3];
    result = intersection_func(segment1, segment2);
    disp(['Expected: No intersection, Got: ', mat2str(result)]);

    % 9. Vertical Line Segment (Undefined Slope)
    disp('Test 9: Vertical Line Segment');
    segment1 = [1 1; 1 5]; % Vertical
    segment2 = [0 3; 2 3];
    result = intersection_func(segment1, segment2);
    disp(['Expected: (1, 3), Got: ', mat2str(result)]);

    % 10. Horizontal Line Segment (Zero Slope)
    disp('Test 10: Horizontal Line Segment');
    segment1 = [0 2; 4 2]; % Horizontal
    segment2 = [2 1; 2 3];
    result = intersection_func(segment1, segment2);
    disp(['Expected: (2, 2), Got: ', mat2str(result)]);

    % 11. Shared Endpoint but No Overlap
    disp('Test 11: Shared Endpoint but No Overlap');
    segment1 = [0 0; 1 1];
    segment2 = [1 1; 2 0];
    result = intersection_func(segment1, segment2);
    disp(['Expected: (1, 1), Got: ', mat2str(result)]);

    % 12. Near-Miss (Numerical Precision Issues)
    disp('Test 12: Near-Miss (Numerical Precision)');
    eps_val = eps; % MATLAB's machine epsilon
    segment1 = [0 0; 1 1];
    segment2 = [1+eps_val 1; 2 0];
    result = intersection_func(segment1, segment2);
    disp(['Expected: No intersection, Got: ', mat2str(result)]);
