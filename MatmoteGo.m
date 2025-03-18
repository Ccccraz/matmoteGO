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
classdef MatmoteGo < handle
    properties ( Access = private )
        baseUri = matlab.net.URI('http://localhost:9012');
        baseSendEndpoint = 'data';
        options = weboptions("MediaType","application/json");
        process;
    end
    methods
        function obj = MatmoteGo()
            runtime = java.lang.Runtime.getRuntime();
            obj.process = runtime.exec('puremotego');
            disp('PuremoteGo started');
        end

        function createEndpoint(obj, endpoint)
            createUri = obj.baseUri;
            createUri.Path = {"create", endpoint};
            respone = webwrite(createUri, []);
            disp(respone);
        end

        function send(obj, msg)
            sendUri = obj.baseUri;
            sendUri.Path = {obj.baseSendEndpoint};

            respone = webwrite(sendUri, msg, obj.options);
            disp(respone);
        end

        function sendTo(obj, msg, endpoint)
            sendUri = obj.baseUri;
            sendUri.Path = {endpoint};

            respone = webwrite(sendUri, msg, obj.options);
            disp(respone);
        end

        function delete(obj)
            obj.process.destroy();
            disp('PuremoteGo stopped');
        end

    end
end
