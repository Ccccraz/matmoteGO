% create a PuremoteGo object
pu = PuremoteGo();

% create a fake data structure
data = struct('name', 'Alice', 'age', 30, 'salary', 50000);

% send data to the default endpoint
for i = 1:10
    pause(1);
    pu.send(data);
end

% create a new endpoint
target = 'data_001';
pu.createEndpoint(target);

% send data to the new endpoint
for i = 1:10
    pause(1);
    pu.sendTo(data, target);
end