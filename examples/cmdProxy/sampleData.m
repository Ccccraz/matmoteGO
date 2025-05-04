classdef sampleData
    properties
        id
        name
        value
        timestamp
        tags
    end
    
    methods
        function obj = sampleData(id, name, value, tags)
            if nargin > 0
                obj.id = id;
                obj.name = name;
                obj.value = value;
                obj.timestamp = datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss');
                obj.tags = tags;
            end
        end
    end
end