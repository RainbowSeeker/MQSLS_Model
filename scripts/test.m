% unknown
syms dvel1 dvel2 dvel3 domega1 domega2 domega3
% input
syms phi theta psi li omega_1 omega_2 omega_3 mi mL J_L;
g = 9.8;
delta_xi = zeros(3, 1);
delta_RL = zeros(3, 1);
delta_xL = zeros(3, 1);
JL = eye(3) * J_L;
dvel = [dvel1 dvel2 dvel3]';
domega = [domega1 domega2 domega3]';
omega = [omega_1 omega_2 omega_3]';
RL = euler_to_dcm(phi, theta, psi);
force_sum = [0 0 0]';
torque_sum = [0 0 0]';
%% i = 1
syms q1_1 q1_2 q1_3 rho1_1 rho1_2 rho1_3 force1_1 force1_2 force1_3 w1_1 w1_2 w1_3
qi = [q1_1 q1_2 q1_3]';
rho_i = [rho1_1 rho1_2 rho1_3]';
force_i = [force1_1 force1_2 force1_3]';
w_i = [w1_1 w1_2 w1_3]';
project_i = qi * qi';
ai = dvel - g * [0 0 1]' + RL * cross(omega, cross(omega, rho_i)) - RL * cross(rho_i, domega);
force_i = project_i * force_i + project_i * delta_xi ...
        - mi * li * norm(w_i)^2 * qi ...
        - mi * project_i * ai;
force_sum = force_sum + force_i;
torque_sum = torque_sum + cross(rho_i, RL' * force_i);
%% i = 2
syms q2_1 q2_2 q2_3 rho2_1 rho2_2 rho2_3 force2_1 force2_2 force2_3 w2_1 w2_2 w2_3
qi = [q2_1 q2_2 q2_3]';
rho_i = [rho2_1 rho2_2 rho2_3]';
force_i = [force2_1 force2_2 force2_3]';
w_i = [w2_1 w2_2 w2_3]';
project_i = qi * qi';
ai = dvel - g * [0 0 1]' + RL * cross(omega, cross(omega, rho_i)) - RL * cross(rho_i, domega);
force_i = project_i * force_i + project_i * delta_xi ...
        - mi * li * norm(w_i)^2 * qi ...
        - mi * project_i * ai;
force_sum = force_sum + force_i;
torque_sum = torque_sum + cross(rho_i, RL' * force_i);
%% i = 3
syms q3_1 q3_2 q3_3 rho3_1 rho3_2 rho3_3 force3_1 force3_2 force3_3 w3_1 w3_2 w3_3
qi = [q3_1 q3_2 q3_3]';
rho_i = [rho3_1 rho3_2 rho3_3]';
force_i = [force3_1 force3_2 force3_3]';
w_i = [w3_1 w3_2 w3_3]';
project_i = qi * qi';
ai = dvel - g * [0 0 1]' + RL * cross(omega, cross(omega, rho_i)) - RL * cross(rho_i, domega);
force_i = project_i * force_i + project_i * delta_xi ...
        - mi * li * norm(w_i)^2 * qi ...
        - mi * project_i * ai;
force_sum = force_sum + force_i;
torque_sum = torque_sum + cross(rho_i, RL' * force_i);
%% solve equation

equation1 = mL * (dvel - g * [0 0 1]') == force_sum + delta_xL;
equation2 = JL * domega + cross(omega, JL * omega) == torque_sum + delta_RL;

solve([equation1 equation2], [dvel1 dvel2 dvel3 domega1 domega2 domega3]);

function so3 = hat_map(r3)
    so3 = [0 -r3(3) r3(2); r3(3) 0 -r3(1); -r3(2) r3(1) 0];
end

function R = euler_to_dcm(phi, theta, psi)
    Rx = [1, 0, 0;
          0, cos(phi), -sin(phi);
          0, sin(phi), cos(phi)];
    Ry = [cos(theta), 0, sin(theta);
          0, 1, 0;
          -sin(theta), 0, cos(theta)];
    Rz = [cos(psi), -sin(psi), 0;
          sin(psi), cos(psi), 0;
          0, 0, 1];
    R = Rz * Ry * Rx;
end