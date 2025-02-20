%% Read csv
log_names = '02-20 16_39_24.csv';
pathname = matlab.project.currentProject().RootFolder + '/asset/';

otable = readtable(fullfile(pathname, log_names));
oidx_start = find(otable.x_sp == 1.975, 1);
oidx_end = find(otable.x_sp == -2.025, 1);
otable = otable(oidx_start:oidx_end, :);

len = length(otable.x);
timestamp = otable{:, 1} / 1e6; % us to s.
timestamp = timestamp - timestamp(1); % From 0
%% draw 3d
figure;
hold on;
set(gca, 'ZDir', 'reverse');
plot3(otable.x, otable.y, otable.z);

% anno
anno_idx = [1, int32(len/2), len];
for idx = anno_idx
    load_position = [otable.x(idx), otable.y(idx), otable.z(idx)];
    uav_position = [
        otable.x1(idx), otable.y1(idx), otable.z1(idx)
        otable.x2(idx), otable.y2(idx), otable.z2(idx)
        otable.x3(idx), otable.y3(idx), otable.z3(idx)
    ];
    uav_euler = [
        0, 0, 0;
        0, 0, 0;
        0, 0, 0;
    ];
    
    draw_mqsls(load_position, uav_position, uav_euler);
end

%% draw top view 
figure;
hold on;
set(gca, 'ZDir', 'reverse');
plot3(otable.x, otable.y, otable.z);

% anno
anno_idx = [1, int32(len/2), len];
for idx = anno_idx
    load_position = [otable.x(idx), otable.y(idx), otable.z(idx)];
    uav_position = [
        otable.x1(idx), otable.y1(idx), otable.z1(idx)
        otable.x2(idx), otable.y2(idx), otable.z2(idx)
        otable.x3(idx), otable.y3(idx), otable.z3(idx)
    ];
    uav_euler = [
        0, 0, 0;
        0, 0, 0;
        0, 0, 0;
    ];
    
    draw_mqsls(load_position, uav_position, uav_euler);
end

view(0, 90);

%% plot result
figure;
hold on;
sgtitle('Cable Direction');

subplot(2, 1, 1);
i = 3;
pL = [otable.x otable.y otable.z];
pi = [otable.("x" + num2str(i)) ...
      otable.("y" + num2str(i)) ...
      otable.("z" + num2str(i))];
perr = pL - pi;
qi = perr ./ vecnorm(perr, 2, 2);
plot(qi);

subplot(2, 1, 2);
plot(otable.margin);
xlabel('time (s)');
ylabel('$\gamma$', 'Interpreter', 'latex');
