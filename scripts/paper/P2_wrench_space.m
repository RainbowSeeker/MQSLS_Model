function [center, radius, Q] = P2_wrench_space(varargin)
T_min = 5 * ones(3, 1);
T_max = 15 * ones(3, 1);
center = [3; -3; -15];

[Q, radius] = mso_forces(center, T_min, T_max);

W = reshape(-Q, 3, 3);
W = W ./ vecnorm(W, 2, 1);
plot_wrench_space(W, T_min, T_max, true, varargin{:});

% 设置坐标轴
axis equal;
grid on;
xlabel('w$_y/N$', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('w$_x/N$', 'Interpreter', 'latex', 'FontSize', 14);
zlabel('w$_z/N$', 'Interpreter', 'latex', 'FontSize', 14);

move_fig();
end