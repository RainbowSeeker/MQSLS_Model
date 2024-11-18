%% Import csv to workspace
defaultPath = '~/catkin_ws/install'; % my workspace

[filename, pathname] = uigetfile({'*.csv', 'CSV Files (*.csv)'}, 'Choose a CSV file', defaultPath);

if isequal(filename, 0) || isequal(pathname, 0)
    return;
end

fullname = fullfile(pathname, filename);
rtable = readtable(fullname);
%% Convert data to Dataset format
% header: timestamp [x y z] [vx vy vz] [x1 y1 z1] [vx1 vy1 vz1] ...
timestamp = rtable{:, 1} / 1e6; % us to s.
ds = Simulink.SimulationData.Dataset;

% add to dataset
ds = addToDataset(ds, 'pL', timeseries(rtable{:, 2:4}, timestamp));
ds = addToDataset(ds, 'vL', timeseries(rtable{:, 5:7}, timestamp));

% calculate cable direction && w
pL = [rtable.x rtable.y rtable.z];
vL = [rtable.vx rtable.vy rtable.vz];
for i = 1:3
    pi = [rtable.("x" + num2str(i)) ...
          rtable.("y" + num2str(i)) ...
          rtable.("z" + num2str(i))];
    perr = pL - pi;
    qi = perr ./ vecnorm(perr, 2, 2);
    
    vi = [rtable.("vx" + num2str(i)) ...
          rtable.("vy" + num2str(i)) ...
          rtable.("vz" + num2str(i))];
    verr = vL - vi;
    wi = verr ./ vecnorm(perr, 2, 2);
    ds = addToDataset(ds, ['q_', num2str(i)], timeseries(qi, timestamp));
    ds = addToDataset(ds, ['w_', num2str(i)], timeseries(wi, timestamp));
end

% plot
simplot(ds);

function ds_out = addToDataset(ds, name, ts)
    signal = Simulink.SimulationData.Signal;
    signal.Name = name;
    signal.Values = ts;

    ds_out = ds.addElement(signal);
end