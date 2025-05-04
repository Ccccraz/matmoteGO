classdef sampleBigData
    properties
        id
        name
        value
        timestamp
        tags
        data
    end
    
    methods
        function obj = sampleBigData(id, name, value, tags)
            if nargin > 0
                obj.id = id;
                obj.name = name;
                obj.value = value;
                obj.timestamp = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
                obj.tags = tags;
                obj.data = rand(1500, 1500, 'single');
            end
        end
    end
end