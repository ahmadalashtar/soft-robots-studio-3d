function add_base_plot_and_node(app, x, y, z, angle)
    % Draw the base as a 3D object
    ps = draw_base(app, x, y, z, angle, app.OptimizerAxes);
    
    % Add the base node to the tree
    node = add_base_node(app, ps, x, y, z,angle);
    
    % Set the selected node in the tree
    app.Tree.SelectedNodes = node;
    
    % Store the node associated with the plot in UserData
    ps.UserData = node;
    
    % Assign a ButtonDownFcn for interaction with the 3D plot
    ps.ButtonDownFcn = @(src, event) ps_mouse_click(app, src);
    
    % Expand the tree to show the selected node
    app.Tree.expand;
    
    % Handle hit testing (you may need to adapt this function for 3D)
    handle_hittest(app);
end
