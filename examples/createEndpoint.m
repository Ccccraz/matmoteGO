function createEndpoint()
remote = MatmoteGo();

endpoint = "trial";
remote.createEndpoint(endpoint);
disp(endpoint + " Created");
data = struct('name', 'Alice', 'age', 30, 'salary', 50000);

for i = 1:10
    remote.sendTo(data, endpoint);
    pause(1);
    disp("Wrote " + num2str(i) + " msg to endpoint: " + endpoint);
end
end
