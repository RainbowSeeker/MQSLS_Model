%% Mark
sim_name = 'normal';

if ~exist('out', 'var')
    return;
end

close all;
%% Payload
figure;
sgtitle(['Payload Trajectory (', sim_name, ')']);
subplot(2, 1, 1);
hold on;
x = out.logsout.find('x').Values;
y = out.logsout.find('y').Values;
z = out.logsout.find('z').Values;
plot(x);
plot(y);
plot(z);
title('Payload Postion');
xlabel('time (s)');
legend('x', 'y', 'z');
hold off;

subplot(2, 1, 2);
hold on;
vx = out.logsout.find('vx').Values;
vy = out.logsout.find('vy').Values;
vz = out.logsout.find('vz').Values;
plot(vx);
plot(vy);
plot(vz);
title('Payload Velocity');
xlabel('time (s)');
legend('vx', 'vy', 'vz');
hold off;

% 3d
% figure;
% sgtitle('3D Trajectory');
% plot3(x.Data, y.Data, z.Data);
% % axis equal;
% hold off;

% clear
clear x y z vx vy vz;

%% Cable
figure;
w_ylim = [-0.5 0.5];
sgtitle(['Cable Direction (', sim_name, ')']);

for i = 1:3
    subplot(3, 2, 2*i-1);
    hold on;
    q = out.logsout.find(['q_', num2str(i)]).Values;
    plot(q);
    title(['Cable ', num2str(i),' Direction']);
    xlabel('time (s)');
    legend('x', 'y', 'z');
    hold off;
    
    subplot(3, 2, 2*i);
    hold on;
    w = out.logsout.find(['w_', num2str(i)]).Values;
    plot(w);
    title(['Cable ', num2str(i),' Angular velocity']);
    xlabel('time (s)');
    ylim(w_ylim);
    legend('x', 'y', 'z');
    hold off;
end

% clear
clear q w w_ylim;

%% UAVs
if isempty(out.logsout.find('phi'))
    return;
end
figure;
sgtitle(['UAV''s Attitude (', sim_name, ')']);

phi = out.logsout.find('phi');
phi_sp = out.logsout.find('phi_sp');
theta = out.logsout.find('theta');
theta_sp = out.logsout.find('theta_sp');

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

% clear
clear phi phi_sp theta theta_sp;