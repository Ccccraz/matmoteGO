function waitCmd()

proxy = matmoteGO.cmdProxy();

while true
    cmdBytes = proxy.getCmd();
    
    if ~isempty(cmdBytes)
        try
            cmdRaw = native2unicode(cmdBytes, 'UTF-8');
            cmd = jsondecode(cmdRaw);
            
            fprintf('received command: %s\n', jsonencode(cmd));
            
            if isfield(cmd, 'cmd')
                switch lower(cmd.cmd)
                    case 'start'
                        disp('Starting...');
                    case 'stop'
                        disp('Stoping...');
                    case 'restart'
                        disp('Restarting...');
                        
                    otherwise
                        fprintf('unknown command: %s\n', cmd.cmd);
                end
            else
                disp('error: no command field');
            end
        catch ME
            fprintf('error: %s\n', ME.message);
        end
    end
    
    disp("Do something...");
    pause(0.5);
end
end