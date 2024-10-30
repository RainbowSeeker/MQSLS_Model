function [sys, x0, str, ts] = payload_with_cable(t, x, u, flag)
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
   sizes.NumContStates  = 24;
   sizes.NumDiscStates  = 0;
   sizes.NumOutputs     = 24;
   sizes.NumInputs      = 9;
   sizes.DirFeedthrough = 0;
   sizes.NumSampleTimes = 1;
   sys = simsizes(sizes);
   % payload initial position && velocity
   pose_0 = [0 0 0]';
   vel_0  = [0 0 0]';
   % cable initial direction && angular velocity
   cable_num = 3;
   initial_condition = 0;
   switch initial_condition
      case 0
         theta_0 = [deg2rad(60) deg2rad(60) deg2rad(60)]';
         psi_0 = [deg2rad(-120) deg2rad(0) deg2rad(120)]';
      case 1
         theta_0 = [deg2rad(30) deg2rad(40) deg2rad(50)]';
         psi_0 = [deg2rad(-110) deg2rad(10) deg2rad(130)]';
      otherwise
         theta_0 = [deg2rad(60) deg2rad(60) deg2rad(60)]';
         psi_0 = [deg2rad(-120) deg2rad(0) deg2rad(120)]';
   end
   
   q_0 = zeros([cable_num * 3 1]);
   w_0 = zeros([cable_num * 3 1]);
   for i = 1:cable_num
      q_0(3*i-2:3*i) = [-cos(psi_0(i)) * cos(theta_0(i)) -sin(psi_0(i)) * cos(theta_0(i)) sin(theta_0(i))]';
      w_0(3*i-2:3*i) = [0 0 0]';
   end
   x0  = [pose_0; vel_0; q_0; w_0];
   str = [];
   ts  = [0 0];
end

function sys = mdlDerivatives(t, x, u)
   %% system parameters
   cable_num = 3;
   mL = 0.06;  % payload mass [kg]
   mi = 0.21;  % quadrotor mass [kg]
   li = [0.6 0.6 0.6]';   % cable length [m]
   g = 9.81;   % gravity [m/s^2]
   dL = 0 * 0.1 * mL * g * [2/3 2/3 1/3]'; % disturbance force on payload [N]
   di = 0 * 0.1 * mi * g * [2/3 2/3 1/3]'; % disturbance force on quadrotor [N]
   %% simulate disturbance
   % pulse disturbance
   % if t > 4 && t < 4.5
   %    dL = 0.1 * mL * g * [2/3 0 0]';
   % end

   %% state variables
   pose = x(1:3);
   vel = x(4:6);
   q = reshape(x(7:15), [3 3]);
   w = reshape(x(16:24), [3 3]);
   
   %% input variables
   force = reshape(u(1:9), [3 3]);

   %% dynamics
   dpose = vel;
   M = mL * eye(3);
   force_sum = [0 0 0]';
   for i = 1:cable_num  % see Eq. (8)
      q(:,i) = q(:,i) / norm(q(:,i));
      project_i = q(:,i) * q(:,i)';
      M = M + mi * project_i;
      force_sum = force_sum + project_i * force(:,i) + project_i * di - mi * li(i) * norm(w(:,i))^2 * q(:,i);
   end
   dvel = M \ force_sum + M \ dL + g * [0 0 1]';
   dq = zeros([3 cable_num]);
   dw = zeros([3 cable_num]);
   for i = 1:cable_num  % see Eq. (1)
      dq(:,i) = cross(w(:,i), q(:,i));
      dw(:,i) = 1 / li(i) * cross(q(:,i), dvel - g * [0 0 1]') - 1 / mi / li(i) * cross(q(:,i), force(:,i) + di);
   end

   flatten_dq = reshape(dq, [cable_num * 3 1]);
   flatten_dw = reshape(dw, [cable_num * 3 1]);
   sys = [dpose; dvel; flatten_dq; flatten_dw];
end

function sys = mdlOutputs(t, x, u)
   q = x(7:15);
   for i = 1:3
      q(3*i-2:3*i) = q(3*i-2:3*i) / norm(q(3*i-2:3*i));
   end
   x(7:15) = q;
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