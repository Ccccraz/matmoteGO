function sendData()
% create a PuremoteGo object
remote = MatmoteGo();

% create a fake data structure
data = struct('name', 'Alice', 'age', 30, 'salary', 50000);

% send data to the default endpoint
for i = 1:10
    pause(1);
    remote.send(data);
    disp("Wrote " + num2str(i) + " msg to data");
end
end