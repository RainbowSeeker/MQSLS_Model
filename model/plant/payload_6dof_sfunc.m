function [sys, x0, str, ts] = payload_6dof_sfunc(t, x, u, flag)
   switch flag
      case 0  % Initialization
         [sys, x0, str, ts] = mdlInitializeSizes;
      case 1  % Derivatives
         sys = mdlDerivatives(t, x, u);
      case 2  % Update
         sys = mdlUpdate(t, x, u);
      case 3  % Outputs
         sys = mdlOutputs(t, x, u);
      case 4  % GetTimeOfNextVarHit
         sys = mdlGetTimeOfNextVarHit(t, x, u);
      case 9  % Terminate
         sys = mdlTerminate(t, x, u);
      otherwise
         error(['Unhandled flag = ', num2str(flag)]);
   end
end

function [sys, x0, str, ts] = mdlInitializeSizes
   sizes = simsizes;
   sizes.NumContStates  = 30;
   sizes.NumDiscStates  = 0;
   sizes.NumOutputs     = 30;
   sizes.NumInputs      = 9;
   sizes.DirFeedthrough = 0;
   sizes.NumSampleTimes = 1;
   sys = simsizes(sizes);
   % payload initial position && velocity
   pose_0 = [0 0 0]';
   vel_0  = [0 0 0]';
   att_0  = [0 0 0]'; % euler angle
   omega_0 = [0 0 0]';
   % cable initial direction && angular velocity
   cable_num = 3;
   initial_condition = 2;
   switch initial_condition
      case 0
         theta_0 = [deg2rad(60) deg2rad(60) deg2rad(60)]';
         psi_0 = [deg2rad(-120) deg2rad(0) deg2rad(120)]';
      case 1
         theta_0 = [deg2rad(80) deg2rad(80) deg2rad(80)]';
         psi_0 = [deg2rad(-110) deg2rad(10) deg2rad(130)]';
      otherwise
         theta_0 = [deg2rad(90) deg2rad(90) deg2rad(90)]';
         psi_0 = [deg2rad(0) deg2rad(0) deg2rad(0)]';
   end
   q_0 = zeros([cable_num * 3 1]);
   w_0 = zeros([cable_num * 3 1]);
   for i = 1:cable_num
      q_0(3*i-2:3*i) = [-cos(psi_0(i)) * cos(theta_0(i)) -sin(psi_0(i)) * cos(theta_0(i)) sin(theta_0(i))]';
      w_0(3*i-2:3*i) = [0 0 0]';
   end
   x0  = [pose_0; vel_0; att_0; omega_0; q_0; w_0];
   str = [];
   ts  = [0 0];
end

function sys = mdlDerivatives(t, x, u)
   %% system parameters
   cable_num = 3;
   mL = 1;  % payload mass [kg]
   JL = eye(3) * 0.0133;
   mi = 1.5;  % quadrotor mass [kg]
   li = 1 * ones(3,1);   % cable length [m]
   g = 9.8;   % gravity [m/s^2]
   rho1 = [0.5 0 -0.1]';
   rho2 = [-0.5 0.4 -0.1]';
   rho3 = [-0.5 -0.4 -0.1]';
   rho = [rho1 rho2 rho3];
   delta_xL = 0 * 0.1 * mL * g * [2/3 2/3 1/3]'; % disturbance force on payload [N]
   delta_RL = 0 * 0.1 * mL * g * [2/3 2/3 1/3]'; % disturbance torque on payload [N*m]
   delta_xi = 0 * 0.1 * mi * g * [2/3 2/3 1/3]'; % disturbance force on quadrotor [N]
   %% simulate disturbance
   % pulse disturbance
   % if t > 4 && t < 4.5
   %    dL = 0.12 * mL * g * [2/3 0 0]';
   % end
   
   %% state variables
   pose = x(1:3);
   vel = x(4:6);
   euler = x(7:9);
   omega = x(10:12);
   q = reshape(x(13:21), [3 3]);
   w = reshape(x(22:30), [3 3]);
   
   %% input variables
   force = reshape(u(1:9), [3 3]);

   %% dynamics
   syms dvel1 dvel2 dvel3 domega1 domega2 domega3;
   dpose = vel;
   dvel = [dvel1 dvel2 dvel3]';
   domega = [domega1 domega2 domega3]';
   RL = euler_to_dcm(euler(1), euler(2), euler(3));
   force_sum = [0 0 0]';
   torque_sum = [0 0 0]';
   for i = 1:cable_num  % see Eq. (8)
      q(:,i) = q(:,i) / norm(q(:,i));
      project_i = q(:,i) * q(:,i)';
      ai = dvel - g * [0 0 1]' + RL * cross(omega, cross(omega, rho(:, i))) - RL * cross(rho(:, i), domega);
      force_i = project_i * force(:,i) + project_i * delta_xi ...
                - mi * li(i) * norm(w(:,i))^2 * q(:,i) ...
                - mi * project_i * ai;
      force_sum = force_sum + force_i;
      torque_sum = torque_sum + cross(rho(:, i), RL' * force_i);
   end
   eq1 = dvel == (force_sum + delta_xL) / mL + g * [0 0 1]';
   eq2 = JL * domega == (torque_sum + delta_RL - cross(omega, JL * omega));

   % solver
   [dvel1, dvel2, dvel3, domega1, domega2, domega3] = solve([eq1 eq2], [dvel1 dvel2 dvel3 domega1 domega2 domega3]);
    
   dvel = double(subs(dvel));
   domega = double(subs(domega));

   datt = [1 sin(euler(1))*tan(euler(2)) cos(euler(1))*tan(euler(2));
           0 cos(euler(1)) -sin(euler(1));
           0 sin(euler(1))/cos(euler(2)) cos(euler(1))/cos(euler(2))] * omega;
   
   dq = zeros([3 cable_num]);
   dw = zeros([3 cable_num]);
   for i = 1:cable_num  % see Eq. (1)
      ai = dvel - g * [0 0 1]' + RL * cross(omega, cross(omega, rho(:, i))) - RL * cross(rho(:, i), domega);
      dq(:,i) = cross(w(:,i), q(:,i));
      dw(:,i) = 1 / li(i) * cross(q(:,i), ai) - 1 / mi / li(i) * cross(q(:,i), force(:,i) + delta_xi);
   end
   
   flatten_dq = reshape(dq, [cable_num * 3 1]);
   flatten_dw = reshape(dw, [cable_num * 3 1]);
   sys = [dpose; dvel; datt; domega; flatten_dq; flatten_dw];
end

function sys = mdlOutputs(t, x, u)
   q = x(13:21);
   for i = 1:3
      q(3*i-2:3*i) = q(3*i-2:3*i) / norm(q(3*i-2:3*i));
   end
   x(13:21) = q;
   sys = x; % output all states
end

function sys = mdlUpdate(t, x, u)
   sys = [];
end

function sys = mdlGetTimeOfNextVarHit(t, x, u)
   sampleTime = 1; % 1 second
   sys = t + sampleTime;
end

function sys = mdlTerminate(t, x, u)
   sys = [];
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