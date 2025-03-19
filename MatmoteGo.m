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
classdef (Sealed) MatmoteGo < handle
    properties ( Access = private )
        process;
    end
    properties (Constant)
        baseUri = matlab.net.URI('http://localhost:9012');
        headers = [matlab.net.http.field.ContentTypeField("application/json")];
        post = matlab.net.http.RequestMethod.POST;
    end
    methods
        function obj = MatmoteGo()
            runtime = java.lang.Runtime.getRuntime();
            obj.process = runtime.exec('cogmoteGO');
            disp('PuremoteGo started');
        end
        
        function createEndpoint(obj, endpoint)
            % create the URL for the request
            createUrl = obj.baseUri;
            createUrl.Path = {"create"};
            msg = struct('name', endpoint);
            
            % create request
            msgBody = matlab.net.http.MessageBody(msg);
            request = matlab.net.http.RequestMessage(obj.post, obj.headers, msgBody);
            
            % send request
            response = obj.sendRequest(request, createUrl);
            obj.handleResponse(response, 'Endpoint created.', 'Endpoint already exists.', 'Invalid endpoint name.');
        end
        
        function send(obj, msg)
            sendUri = obj.baseUri;
            sendUri.Path = {"data"};
            
            msgBody = matlab.net.http.MessageBody(msg);
            request = matlab.net.http.RequestMessage(obj.post, obj.headers, msgBody);
            
            response = obj.sendRequest(request, sendUri);
            obj.handleResponse(response, 'Message sent', '', 'Invalid message');
        end
        
        function sendTo(obj, msg, endpoint)
            sendUri = obj.baseUri;
            sendUri.Path = {endpoint};
            
            msgBody = matlab.net.http.MessageBody(msg);
            request = matlab.net.http.RequestMessage(obj.post, obj.headers, msgBody);
            
            response = obj.sendRequest(request, sendUri);
            obj.handleResponse(response, 'Message sent', '', 'Invalid message');
        end
        
        function delete(obj)
            obj.process.destroy();
            disp('PuremoteGo stopped');
        end
    end
    methods (Access = private)
        function response = sendRequest(~, request, uri)
            try
                response = request.send(uri);
            catch exception
                disp("Error: Failed to send request - " + exception.message);
                response = [];
            end
        end
        
        function handleResponse(~, response, successMsg, conflictMsg, badRequestMsg)
            % handle HTTP response based on status code
            if isempty(response)
                return;
            end
            switch response.StatusCode
                case matlab.net.http.StatusCode.Created
                    disp("Success: " + successMsg);
                case matlab.net.http.StatusCode.Conflict
                    disp("Warning: " + conflictMsg);
                case matlab.net.http.StatusCode.OK
                    disp("Success: " + successMsg);
                case matlab.net.http.StatusCode.BadRequest
                    disp("Error: " + badRequestMsg);
                    disp("Message from cogmoteGO: " + response.Body.show());
                case matlab.net.http.StatusCode.NotFound
                    disp("Error: Endpoint not found.");
                otherwise
                    disp("Error: Unknown error: " + response.StatusCode + " - " + response.Body.show());
            end
        end
    end
end
