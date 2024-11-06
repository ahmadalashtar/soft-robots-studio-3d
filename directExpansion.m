function path = directExpansion(lengthMin, step_size, start_conf, end_conf)    
    config = start_conf;
    path = {config};
    
    while path{end} ~= end_conf
        config = greedyExpand(lengthMin, step_size, config, end_conf);

        if isempty(config)
            break;
        end

        path = [path, config];
    end
    
end
