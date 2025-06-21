classdef cmdProxy < handle
    properties
        context jzmq.ZContext
        socket jzmq.ZMQ.Socket
        poller jzmq.ZMQ.Poller
    end
    
    properties (Constant)
        hostname = 'localhost';
        port = 5555;
        baseUri = matlab.net.URI('http://localhost:9012');
        basePath = {"api", "cmds", "proxies"};
        headers = [matlab.net.http.field.ContentTypeField("application/json")];
    end
    
    methods
        function obj = cmdProxy()
            obj.createZmq();
            obj.createProxy();
            obj.handShake();
        end
        
        function cmd = getCmd(obj)
            arguments (Output)
                cmd (1, :) uint8
            end
            
            events = obj.poller.poll(0); % poll for 0 milliseconds
            
            if events > 0
                cmd = obj.socket.recv();

                data = struct('result', 'ok');
                dataStr = jsonencode(data);

                obj.socket.send(dataStr);
            else
                cmd = [];
            end
        end
        
        function delete(obj)
            obj.socket.close();
            obj.closeProxy();
        end
        
    end
    
    methods (Access = private)
        function createZmq(obj)
            obj.context = jzmq.ZContext();
            obj.socket = obj.context.createSocket(jzmq.SocketType.REP);
            obj.poller = obj.context.createPoller(1);

            obj.poller.register(obj.socket, jzmq.ZMQ.PollerEvent.POLLIN)
            
            url = sprintf('tcp://%s:%d', obj.hostname, obj.port);
            
            obj.socket.bind(url);
        end
        
        function createProxy(obj)
            % create the URL for the request
            cmdProxyUrl = obj.baseUri;
            cmdProxyUrl.Path = obj.basePath;
            
            msg = struct('nickname', 'matlab', 'hostname', obj.hostname, "port", obj.port);
            msgBody = matlab.net.http.MessageBody(msg);
            request = matlab.net.http.RequestMessage(matlab.net.http.RequestMethod.POST, obj.headers, msgBody);
            
            % send request
            response = obj.sendRequest(request, cmdProxyUrl);
            obj.handleResponse(response);
        end
        
        function handShake(obj)
            try
                msgBytes = obj.socket.recv();
                
                if isempty(msgBytes)
                    warning('No handshake message received');
                end
                
                msgStr = native2unicode(msgBytes, 'UTF-8');
                receivedMsg = jsondecode(msgStr);
                fprintf('Received: %s\n', receivedMsg.request);
                
                if strcmp(receivedMsg.request, 'Hello')
                    response = struct('response', 'World');
                    responseStr = jsonencode(response);
                    responseBytes = unicode2native(responseStr, 'UTF-8');
                    obj.socket.send(responseBytes);
                else
                    warning('Invalid handshake request: %s', msgStr);
                end

            catch exception
                warning(exception.identifier, 'Handshake failed: %s', exception.message);
                rethrow(exception);
            end
        end

        function closeProxy(obj)
            % create the URL for the request
            cmdProxyUrl = obj.baseUri;
            cmdProxyUrl.Path = [obj.basePath, "matlab"]

            request = matlab.net.http.RequestMessage(matlab.net.http.RequestMethod.DELETE);
            
            % send request
            response = obj.sendRequest(request, cmdProxyUrl);
            obj.handleResponse(response);
        end
        
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