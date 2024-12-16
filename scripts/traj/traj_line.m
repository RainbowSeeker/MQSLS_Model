function [pos, vel, acc] = traj_line(timestamp)

% Trajectory parameters
cruise_speed = 2;           % Cruise speed
max_accel = 1;              % Maximum acceleration
max_decel = 1;              % Maximum deceleration
start_pos = [0; 0; 0];      % Starting position

% Position
pos = [50; 0; -10];

% Velocity
vel = [0; 0; 0];

% Acceleration
acc = [0; 0; 0];
end