function nodes = add_base_node(app, src, x, y,z, angle)
    % Adds the base node to the right tree
    
    % Create a struct for the node data
    data = struct('child', src, 'x', x, 'y', y, 'z',z, 'x angle', Xangle);
    
    % Define the text to display in the tree for each node
    text = "x: " + string(round(x,2)) + ", y: " + string(round(y,2)) +", z: " + string(round(y,2)) +", angle: " + string(round(angle,2));
    
    % Create a new tree node with the data and the text
    node = uitreenode(app.BaseNode, "NodeData", data, "Text", text);
    
    % Store the created node in a vector (if you need multiple nodes)
    nodes = node;  % For now, just 1 node, but you can create a vector of nodes later if needed
end
