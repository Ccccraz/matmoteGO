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
classdef (Sealed) broadcast < handle
    properties ( Access = private )
        process;
    end
    properties (Constant)
        baseUri = matlab.net.URI('http://localhost:9012');
        headers = [matlab.net.http.field.ContentTypeField("application/json")];
        post = matlab.net.http.RequestMethod.POST;
    end
    methods
        function obj = broadcast()
        end
        
        function response = createEndpoint(obj, endpoint)
            % create the URL for the request
            createUrl = obj.baseUri;
            createUrl.Path = {"create"};
            msg = struct('name', endpoint);
            
            % create request
            msgBody = matlab.net.http.MessageBody(msg);
            request = matlab.net.http.RequestMessage(obj.post, obj.headers, msgBody);
            
            % send request
            response = obj.sendRequest(request, createUrl);
            obj.handleResponse(response);
        end
        
        function response = send(obj, msg)
            sendUri = obj.baseUri;
            sendUri.Path = {"data"};
            
            msgBody = matlab.net.http.MessageBody(msg);
            request = matlab.net.http.RequestMessage(obj.post, obj.headers, msgBody);
            
            response = obj.sendRequest(request, sendUri);
            obj.handleResponse(response);
        end
        
        function response = sendTo(obj, msg, endpoint)
            sendUri = obj.baseUri;
            sendUri.Path = {endpoint};
            
            msgBody = matlab.net.http.MessageBody(msg);
            request = matlab.net.http.RequestMessage(obj.post, obj.headers, msgBody);
            
            response = obj.sendRequest(request, sendUri);
            obj.handleResponse(response);
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
        
        function response = handleResponse(~, response)
            % handle HTTP response based on status code
            if isempty(response)
                return;
            end
            
            switch response.StatusCode
                case matlab.net.http.StatusCode.Conflict
                    warning("MatmoteGo:endpointExists", "Endpoint already exists");
                case matlab.net.http.StatusCode.BadRequest
                    warning("MatmoteGo:invalidRequest", "Message from cogmoteGO: %s", response.Body.show());
                case matlab.net.http.StatusCode.NotFound
                    warning("MatmoteGo:invalidEndpoint", "Endpoint not found");
            end
        end
    end
end
