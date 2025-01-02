theta = repmat(deg2rad(60), 3, 1);
psi = [deg2rad(-120); deg2rad(0); deg2rad(120)];
q = zeros([3 3]);
for i = 1:3
  q(:, i) = [-cos(psi(i)) * cos(theta(i)) -sin(psi(i)) * cos(theta(i)) sin(theta(i))];
end

T_min = [0; 0; 0];
T_max = 7 * ones(3, 1);
F_trim = [0;0;-10];
F_way = [0;3;-2];

[result, F_actual] = PWAS(F_trim, F_way, q, T_min, T_max);

