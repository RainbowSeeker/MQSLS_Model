%% Import csv to workspace
defaultPath = '~/rain_ws/install'; % my workspace

[filename, pathname] = uigetfile({'*.csv', 'CSV Files (*.csv)'}, 'Choose a CSV file', defaultPath);

if isequal(filename, 0) || isequal(pathname, 0)
    return;
end

fullname = fullfile(pathname, filename);
fileinfo = dir(fullname);
rtable = readtable(fullname);
%% Convert data to Dataset format
% header: timestamp [x y z] [vx vy vz] [x1 y1 z1] [vx1 vy1 vz1] ...
timestamp = rtable{:, 1} / 1e6; % us to s.
ds = Simulink.SimulationData.Dataset;

% calculate cable direction && w
pL = [rtable.x rtable.y rtable.z];
vL = [rtable.vx rtable.vy rtable.vz];

% add to dataset
ds = addToDataset(ds, 'pL', timeseries(pL, timestamp));
ds = addToDataset(ds, 'vL', timeseries(vL, timestamp));

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
    dot_qi = verr ./ vecnorm(perr, 2, 2);
    wi = zeros(size(dot_qi));
    for j = 1:size(dot_qi, 1)
        wi(j, :) = cross(qi(j, :), dot_qi(j, :));
    end
    % qi = [rtable.("qx" + num2str(i)) rtable.("qy" + num2str(i)) rtable.("qz" + num2str(i))];
    % wi = [rtable.("wx" + num2str(i)) rtable.("wy" + num2str(i)) rtable.("wz" + num2str(i))];
    ds = addToDataset(ds, ['q_', num2str(i)], timeseries(qi, timestamp));
    ds = addToDataset(ds, ['w_', num2str(i)], timeseries(wi, timestamp));
end

% plot
simplot(ds, fileinfo.date);

function ds_out = addToDataset(ds, name, ts)
    signal = Simulink.SimulationData.Signal;
    signal.Name = name;
    signal.Values = ts;

    ds_out = ds.addElement(signal);
end