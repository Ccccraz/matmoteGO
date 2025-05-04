function sendCmd()
commandList = {'start', 'stop', 'restart'};

options = weboptions(...
    'MediaType', 'application/json', ...
    'ContentType', 'json', ...
    'CharacterEncoding', 'UTF-8' ...
    );

apiEndpoint = 'http://localhost:9012/cmds/proxies/matlab';

for i = 1:10
    selectedCmd = commandList{randi(length(commandList))};
    
    dataStruct = struct('cmd', selectedCmd);
    
    try
        response = webwrite(apiEndpoint, dataStruct, options);
        
        fprintf('[try %d] send "%s" - respone: %s\n', ...
            i, selectedCmd, jsonencode(response));
        
    catch ME
        fprintf('[try %d] send "%s" failed - error: %s\n', ...
            i, selectedCmd, ME.message);
    end
end
end