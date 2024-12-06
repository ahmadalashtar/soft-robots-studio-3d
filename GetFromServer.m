function data = GetFromServer(ip, maxDelay)
    url = sprintf('http://%s:%s', ip, "3753");


    computerName = getenv('COMPUTERNAME');
    % numbers = regexp(computerName, '\d+', 'match');
	options = weboptions('HeaderFields', {'ComputerName', computerName}); % Add the computerName as a header

    minDelay = 1;
    
    
    delay = round(minDelay + (maxDelay - minDelay) * rand());
    fprintf('Delaying for %d seconds\n', delay);
    pause(delay); % Pause for the random duration to not DDOS the server.
    
    
    % options = weboptions('RequestMethod', 'post', 'MediaType', 'application/json');
    % payload = struct('computerNo', computerNo);
    % data = webwrite(url, payload, options);
	
	for i = 1:100
		data = webread(url, options);
		if isfield(data, 'message')
			fprintf('Stopping with message : %s\nI ran %d experiments.\n', data.message, i);
            % !taskkill /F /im "matlab.exe"
			return
		end
		display(data);
		experiment_main(data);
		delay = round(minDelay + (maxDelay - minDelay) * rand());
        fprintf("Finished Experiment. Delaying for %d seconds before asking for another.\n", delay);
		pause(delay);
	end
    
    
    % fprintf('Recieved Data : \n\tID: %d\n', data.id);
    % fprintf('\tFunction: F%d\n', data.func);
    % fprintf('\tPopulation Size: %s\n', strjoin(string(data.pop), " | "));
    % fprintf('\tNumber: %d\n', data.number);
    
    % index = 0;
    % for func = 1:height(data.func)
    %     for pop = 1:height(data.pop)
    %         for num = 1:height(data.number)
    %             index = index + 1;
    %             fprintf('Running attempt %d\n', index);
    %         end
    %     end
    % end
end