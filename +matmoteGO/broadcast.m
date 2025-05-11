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
    properties
        boardcasts (1, :) string
    end
    properties (Constant)
        baseUri = matlab.net.URI('http://localhost:9012');
        basePath = {'broadcast', 'data'};
        headers = [matlab.net.http.field.ContentTypeField("application/json")];
        http_post = matlab.net.http.RequestMethod.POST;
        http_delete = matlab.net.http.RequestMethod.DELETE;
    end
    methods
        function obj = broadcast()
        end
        
        function response = createBroadcast(obj, endpoint)
            arguments (Input)
                obj
                endpoint string
            end
            
            obj.boardcasts(end+1) = endpoint;
            % create the URL for the request
            createUrl = obj.baseUri;
            createUrl.Path = obj.basePath;
            msg = struct('name', endpoint);
            
            % create request
            msgBody = matlab.net.http.MessageBody(msg);
            request = matlab.net.http.RequestMessage(obj.http_post, obj.headers, msgBody);
            
            % send request
            response = obj.sendRequest(request, createUrl);
            obj.handleResponse(response);
        end
        
        function response = send(obj, msg)
            arguments (Input)
                obj
                msg struct
            end
            
            % create the URL for the request
            sendUri = obj.baseUri;
            sendUri.Path = [obj.basePath, 'default'];
            
            msgBody = matlab.net.http.MessageBody(msg);
            request = matlab.net.http.RequestMessage(obj.http_post, obj.headers, msgBody);
            
            response = obj.sendRequest(request, sendUri);
            obj.handleResponse(response);
        end
        
        function response = sendTo(obj, msg, endpoint)
            arguments (Input)
                obj
                msg struct
                endpoint string
            end
            
            sendUri = obj.baseUri;
            sendUri.Path = [obj.basePath, endpoint];
            
            msgBody = matlab.net.http.MessageBody(msg);
            request = matlab.net.http.RequestMessage(obj.http_post, obj.headers, msgBody);
            
            response = obj.sendRequest(request, sendUri);
            obj.handleResponse(response);
        end
        
        function response = closeBroadcast(obj, endpoint)
            arguments (Input)
                obj
                endpoint string
            end
            
            deleteUri = obj.baseUri;
            deleteUri.Path = [obj.basePath, endpoint];
            
            request = matlab.net.http.RequestMessage(obj.http_delete, obj.headers, []);
            response = obj.sendRequest(request, deleteUri);
            obj.handleResponse(response);
        end
        
        function delete(obj)
            % delete all endpoints
            if ~isempty(obj.boardcasts)
                for i = 1:length(obj.boardcasts)
                    obj.closeBroadcast(obj.boardcasts{i});
                end
            end
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
