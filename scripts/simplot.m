function simplot(varargin)
%% Mark
sim_name = 'normal';

if ~isempty(varargin)
    dataset = varargin{1};
    sim_name = varargin{2};
else
    % default data source
    dataset = evalin('base', 'out.logsout'); 
end

if ~exist('dataset', 'var')
    disp('No available data source.');
    return;
end

% close all;
%% Payload
figure;
sgtitle(['Payload Trajectory (', sim_name, ')']);
subplot(2, 1, 1);
hold on;
pL = dataset.find('pL').Values;
plot(pL);
title('Payload Postion');
xlabel('time (s)');
legend('x', 'y', 'z');
hold off;

subplot(2, 1, 2);
hold on;
vL = dataset.find('vL').Values;
plot(vL);
title('Payload Velocity');
xlabel('time (s)');
legend('vx', 'vy', 'vz');
% ylim([-10 10]);
hold off;

% 3d
figure;
sgtitle(['3D Trajectory (', sim_name, ')']);
plot3(pL.Data(:, 1), pL.Data(:, 2), pL.Data(:, 3));
axis equal;
hold off;

if ~isempty(dataset.find('euler'))
figure;
sgtitle(['Payload Attitude (', sim_name, ')']);
subplot(2, 1, 1);
hold on;
euler = dataset.find('euler').Values * rad2deg(1);
plot(euler);
title('Payload Attitude (deg)');
xlabel('time (s)');
legend('phi', 'theta', 'psi');
hold off;

subplot(2, 1, 2);
hold on;
omega = dataset.find('omega').Values * rad2deg(1);
plot(omega);
title('Payload Angle Rate (deg/s)');
xlabel('time (s)');
legend('p', 'q', 'r');
hold off;
end

%% Cable
figure;
sgtitle(['Cable Direction (', sim_name, ')']);

for i = 1:3
    subplot(3, 2, 2*i-1);
    hold on;
    q = dataset.find(['q_', num2str(i)]).Values;
    plot(q);
    title(['Cable ', num2str(i),' Direction']);
    xlabel('time (s)');
    legend('x', 'y', 'z');
    hold off;
    
    subplot(3, 2, 2*i);
    hold on;
    w = dataset.find(['w_', num2str(i)]).Values;
    plot(w);
    title(['Cable ', num2str(i),' Angular velocity']);
    xlabel('time (s)');
    ylim([-0.5 0.5]);
    legend('x', 'y', 'z');
    hold off;
end

%% UAVs

if isempty(dataset.find('phi'))
    return;
end
figure;
sgtitle(['UAV''s Attitude (', sim_name, ')']);

phi = dataset.find('phi');
phi_sp = dataset.find('phi_sp');
theta = dataset.find('theta');
theta_sp = dataset.find('theta_sp');

for i = 1:3
    subplot(3, 2, 2*i - 1);
    hold on;
    phi{i}.Values.Data = rad2deg(phi{i}.Values.Data);
    phi_sp{i}.Values.Data = rad2deg(phi_sp{i}.Values.Data);
    plot(phi{i}.Values);
    plot(phi_sp{i}.Values);
    title(['UAV', num2str(i), '''s phi']);
    xlabel('time (s)');
    legend('phi', 'phi_{sp}');
    hold off;
    
    subplot(3, 2, 2*i);
    hold on;
    theta{i}.Values.Data = rad2deg(theta{i}.Values.Data);
    theta_sp{i}.Values.Data = rad2deg(theta_sp{i}.Values.Data);
    plot(theta{i}.Values);
    plot(theta_sp{i}.Values);
    title(['UAV', num2str(i), '''s theta']);
    xlabel('time (s)');
    legend('theta', 'theta_{sp}');
    hold off;
end

end