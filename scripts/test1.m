choose = 0;
switch choose
  case 0
     theta = [deg2rad(60) deg2rad(60) deg2rad(60)]';
     psi = [deg2rad(-120) deg2rad(0) deg2rad(120)]';
  case 1
     theta = [deg2rad(60) deg2rad(20) deg2rad(60)]';
     psi = [deg2rad(-120) deg2rad(0) deg2rad(120)]';
  otherwise
     theta = [deg2rad(90) deg2rad(90) deg2rad(90)]';
     psi = [deg2rad(0) deg2rad(0) deg2rad(0)]';
end
Q = zeros([3 3]);
for i = 1:3
  Q(:, i) = [-cos(psi(i)) * cos(theta(i)) -sin(psi(i)) * cos(theta(i)) sin(theta(i))]';
end

F_sp = [-5.1703 -5.2525 -10.4916]';
min_tension = 0;
max_tension = 200;
%% 张力约束下的迭代求解器
[result, F_actual] = TCIS(Q, F_sp, min_tension, max_tension);

disp('Result:')
disp(result);
disp('Expected: Actual:');
disp([F_sp F_actual]);