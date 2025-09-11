classdef (Sealed) status < handle
    properties (Constant)
        baseUri = matlab.net.URI('http://localhost:9012');
        basePath = {'api', 'status'};
        headers = [matlab.net.http.field.ContentTypeField("application/json")];
        http_get = matlab.net.http.RequestMethod.GET;
        http_patch = matlab.net.http.RequestMethod.PATCH;
    end

    methods
        function obj = status()
        end

        function response = updateStatusToRunning(obj)
            msg = struct('is_running', true);
            response = obj.updateStatus(msg);
        end

        function response = updateStatusToStopped(obj)
            msg = struct('is_running', false);
            response = obj.updateStatus(msg);
        end

        function response = updateStatus(obj, msg)
            msgBody = matlab.net.http.MessageBody(msg);
            request = matlab.net.http.RequestMessage(obj.http_patch, obj.headers, msgBody);

            updateUrl = obj.baseUri;
            updateUrl.Path = obj.basePath;

            response = obj.sendRequest(request, updateUrl);
        end

        function respone = getStatus(obj)
            request = matlab.net.http.RequestMessage(obj.http_get, obj.headers);
            updateUrl = obj.baseUri;
            updateUrl.Path = obj.basePath;
            respone = obj.sendRequest(request, updateUrl);
        end
    end

    methods (Access = private)
        function response = sendRequest(~, request, url)
            try
                response = request.send(url);
            catch exception
                disp("Error: Failed to send request - " + exception.message);
                response = [];
            end
        end
    end
end