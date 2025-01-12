[center, radius] = P2_wrench_space();

% Plot ball
[x, y, z] = sphere(50);
x_new = radius * x + center(2);
y_new = radius * y + center(1);
z_new = radius * z + center(3);
surf(x_new, y_new, z_new, 'FaceColor', 'flat', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
