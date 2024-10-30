%% Mark
sim_name = 'normal';

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
%% Cable
figure;
w_ylim = [-0.5 0.5];
sgtitle(['Cable Direction (', sim_name, ')']);

subplot(3, 2, 1);
hold on;
q_1 = out.logsout.find('q_1').Values;
plot(q_1);
title('Cable 1 Direction');
xlabel('time (s)');
legend('x', 'y', 'z');
hold off;

subplot(3, 2, 2);
hold on;
w_1 = out.logsout.find('w_1').Values;
plot(w_1);
title('Cable 1 Angular velocity');
xlabel('time (s)');
ylim(w_ylim);
legend('x', 'y', 'z');
hold off;

subplot(3, 2, 3);
hold on;
q_2 = out.logsout.find('q_2').Values;
plot(q_2);
title('Cable 2 Direction');
xlabel('time (s)');
legend('x', 'y', 'z');
hold off;

subplot(3, 2, 4);
hold on;
w_2 = out.logsout.find('w_2').Values;
plot(w_2);
title('Cable 2 Angular velocity');
xlabel('time (s)');
ylim(w_ylim);
legend('x', 'y', 'z');
hold off;

subplot(3, 2, 5);
hold on;
q_3 = out.logsout.find('q_3').Values;
plot(q_3);
title('Cable 3 Direction');
xlabel('time (s)');
legend('x', 'y', 'z');
hold off;

subplot(3, 2, 6);
hold on;
w_3 = out.logsout.find('w_3').Values;
plot(w_3);
title('Cable 3 Angular velocity');
xlabel('time (s)');
ylim(w_ylim);
legend('x', 'y', 'z');
hold off;

%% over