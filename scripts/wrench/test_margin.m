T_min = [0; 0; 0];
T_max = 20 * ones(3, 1);
theta = repmat(deg2rad(20), 3, 1);
psi = [deg2rad(-120) deg2rad(0) deg2rad(120)]';
q = zeros([3 3]);
for i = 1:3
  q(:, i) = [-cos(psi(i)) * cos(theta(i)) -sin(psi(i)) * cos(theta(i)) sin(theta(i))];
end
W = -q;
center = [-2; -2; -10];

% solver
margin = margin_lp(center, W, T_min, T_max);

disp(['margin:', num2str(margin)]);

% Plot
plot_wrench_space(W, T_min, T_max);
hold on;
% Plot ball
radius = margin;
[x, y, z] = sphere(50);
x_new = radius * x + center(2);
y_new = radius * y + center(1);
z_new = radius * z + center(3);
surf(x_new, y_new, z_new, 'FaceColor', 'b', 'FaceAlpha', 0.5, 'EdgeColor', 'none');

title(['margin = ', num2str(margin)]);
hold off;
