% PuremoteGo.m
%
% PuremoteGo - A MATLAB class for interacting with PuremoteGo
%
% Properties:
%
% Methods:
% PuremoteGo - Constructor: Starts puremotego.exe
% createEndpoint - Creates an endpoint
% send - Sends a message to the PuremoteGo default endpoint
% sendTo - Sends a message to a specific endpoint
%
%
classdef PuremoteGo < handle
    properties ( Access = private )
        baseUrl = 'http://localhost:9012';
        options = weboptions("MediaType","application/json");
        baseSendEndpoint = '/data';
        process;
    end
    methods
        function obj = PuremoteGo()
            runtime = java.lang.Runtime.getRuntime();
            obj.process = runtime.exec('puremotego.exe');
            disp('PuremoteGo started');
        end
        
        function createEndpoint(obj, endpoint)
            createUrl = strcat(obj.baseUrl, '/create', '/', endpoint);
            respone = webwrite(createUrl, []);
            disp(respone);
        end
        
        function send(obj, msg)
            SendUrl = strcat(obj.baseUrl, obj.baseSendEndpoint);
            respone = webwrite(SendUrl, msg, obj.options);
            disp(respone);
        end
        
        function sendTo(obj, msg, endpoint)
            sendUrl = strcat(obj.baseUrl, '/', endpoint);
            respone = webwrite(sendUrl, msg, obj.options);
            disp(respone);
        end
        
        function delete(obj)
            obj.process.destroy();
            disp('PuremoteGo stopped');
        end
        
    end
end
