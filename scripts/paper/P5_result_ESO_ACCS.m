
log_names = [
    '02-18 19_34_24.csv';   % comp
    '02-18 19_35_44.csv';   % own
];

pathname = matlab.project.currentProject().RootFolder + '/asset/';

% comp
ctable = readtable(fullfile(pathname, log_names(1, :)));
cidx_slice = find(ctable.x_sp == 2, 3);
ctable = ctable(cidx_slice(1):cidx_slice(end), :);
% own
otable = readtable(fullfile(pathname, log_names(2, :)));
oidx_slice = find(otable.x_sp == 2, 3);
otable = otable(oidx_slice(1):oidx_slice(end), :);

timestamp = otable{:, 1} / 1e6; % us to s.
timestamp = timestamp - timestamp(1); % From 0

%% Compare 3d traj
figure;
hold on;
plot3(otable.x_sp, otable.y_sp, otable.z_sp, 'r');
plot3(otable.x, otable.y, otable.z, 'g');
plot3(ctable.x, ctable.y, ctable.z, 'b');
% axis equal;
grid on;
zlim([-1.5 -0.5]);
view(3);

%% Compare x y z
figure;
subplot(3, 1, 1);
hold on;
plot(timestamp, otable.x_sp, 'r');
plot(timestamp, otable.x, 'g');
plot(timestamp, ctable.x, 'b');
xlim([0 40]);
% ylim([-2 2]);
ylabel('$x_L\,(m)$', 'Interpreter', 'latex', 'FontSize', 10);

subplot(3, 1, 2);
hold on;
plot(timestamp, otable.y_sp, 'r');
plot(timestamp, otable.y, 'g');
plot(timestamp, ctable.y, 'b');
xlim([0 40]);
% ylim([-2 2]);
ylabel('$y_L\,(m)$', 'Interpreter', 'latex', 'FontSize', 10);

subplot(3, 1, 3);
hold on;
plot(timestamp, otable.z_sp, 'r');
plot(timestamp, otable.z, 'g');
plot(timestamp, ctable.z, 'b');
xlim([0 40]);
ylim([-1.5 -0.5]);
ylabel('$z_L\,(m)$', 'Interpreter', 'latex', 'FontSize', 10);

xlabel('Time (s)');

%% Compare tau
figure;
subplot(3, 1, 1);
hold on;
% plot(timestamp, otable.x_sp, 'r');
plot(timestamp, -otable.taux, 'g');
plot(timestamp, -ctable.taux, 'b');
xlim([0 40]);
% ylim([-2 2]);
ylabel('$taux\,(N)$', 'Interpreter', 'latex', 'FontSize', 10);

subplot(3, 1, 2);
hold on;
% plot(timestamp, otable.y_sp, 'r');
plot(timestamp, -otable.tauy, 'g');
plot(timestamp, -ctable.tauy, 'b');
xlim([0 40]);
% ylim([-2 2]);
ylabel('$tauy\,(N)$', 'Interpreter', 'latex', 'FontSize', 10);

subplot(3, 1, 3);
hold on;
% plot(timestamp, otable.z_sp, 'r');
plot(timestamp, -otable.tauz, 'g');
plot(timestamp, -ctable.tauz, 'b');
xlim([0 40]);
% ylim([-1.5 -0.5]);
ylabel('$tau\,(N)$', 'Interpreter', 'latex', 'FontSize', 10);

xlabel('Time (s)');