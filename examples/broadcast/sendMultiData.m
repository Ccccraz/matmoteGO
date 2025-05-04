function sendMultiData()

remote = matmoteGO.broadcast();

% create custom endpoint trial1 and trial2
endpoint_1 = "trial1";
endpoint_2 = "trial2";
remote.createEndpoint(endpoint_1);
remote.createEndpoint(endpoint_2);

% prepare data for three different endpoints
data = struct('name', 'abc', 'age', 10, 'salary', 50000);
data_1 = struct('name', 'bca', 'age', 20, 'salary', 50000);
data_2 = struct('name', 'cba', 'age', 30, 'salary', 50000);

for i = 1:10
    pause(1);
    remote.send(data); % send data to default endpoint: data
    remote.sendTo(data_1, endpoint_1); % send data to trial_001 endpoint
    remote.sendTo(data_2, endpoint_2); % send data to trial_002 endpoint
end

end