function [pos, vel, acc] = traj_circle(timestamp)
% Circular Trajectory Generator
% Input : dt
% Output: position, velocity, and acceleration

% Trajectory parameters
radius = 10;               % Radius of the circle
omega = deg2rad(10);       % Angular velocity
x_center = 0;              % x-coordinate of the circle center
y_center = 0;              % y-coordinate of the circle center
height = 10;               % Height of the circle
theta_start = 0;           % Starting angle

% Position
theta = theta_start + omega*timestamp;
x_traj = x_center + radius*cos(theta);
y_traj = y_center + radius*sin(theta);
z_traj = -height;
pos = [x_traj; y_traj; z_traj];

% Velocity
x_vel = -radius*omega*sin(theta);
y_vel = radius*omega*cos(theta);
z_vel = 0;
vel = [x_vel; y_vel; z_vel];

% Acceleration
x_acc = -radius*(omega^2)*cos(theta);
y_acc = -radius*(omega^2)*sin(theta);
z_acc = 0;
acc = [x_acc; y_acc; z_acc];
end