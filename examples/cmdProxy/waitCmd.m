function waitCmd()
    proxy = matmoteGO.cmdProxy();

    while true
        cmdBytes = proxy.getCmd();
        if ~isempty(cmdBytes)
            cmdRaw = native2unicode(cmdBytes, 'UTF-8');
            cmd = jsondecode(cmdRaw);
            disp(cmd);
        end
        pause(1);
    end
end