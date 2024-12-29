% a group of settings for the first Task in the experiment

function firstTask(exp_flag)
    global op;
    if nargin == 0
        exp_flag=0;
    end
    
    op.planes = [-20, 150];
    op.n_links = 20;
    op.length_domain = [25 70];
    op.home_base = [0 0 0 0 0];
    op.first_angle.is_fixed = true;
    op.angle_domain = [-45 45];
    op.first_angle.angle = 0;

    t1 = [145 -30 100 ];
    t2 = [145 30 100 ];
    op.targets = [  t1 -15 65;
                    t2 15 65;
                    ]; %target [x y z ux uy uz cone_angle]
                    % ]; %target [x y z ux uy uz cone_angle]
    op.obstacles = [
                    85 0 150 12.5 150;
                    45 40.79492 150 12.5 150;
                    45 -40.79492 150 12.5 150;
                    145 -30 150 12.5 45;
                    145 30 150 12.5 45;
                    ]; %cylinder [x y z(base) radius height]

    
    op.end_points = retrieveOrientationSegmentEndPoints3D(op.targets,op.obstacles,op.home_base);  % retrieve the end points for each target's orientation segment
    
    % % drawProblem3D([]);

    
end