T_min = zeros(3, 1);
T_max = 7 * ones(3, 1);
center = [0; 3; -10];

tic; % 开始计时
for time =1:1
    [Q, radius] = mso_forces(center, T_min, T_max);
end
elapsedTime = toc; % 结束计时并获取时间
disp(['运行时间: ', num2str(elapsedTime), ' 秒']);

W = reshape(-Q, 3, 3);
W = W ./ vecnorm(W, 2, 1);
plot_wrench_space(W, T_min, T_max);

% Plot ball
hold on;
title(['radius  ', num2str(radius)]);
[x, y, z] = sphere(50);
x_new = radius * x + center(2);
y_new = radius * y + center(1);
z_new = radius * z - center(3);
surf(x_new, y_new, z_new, 'FaceColor', 'b', 'FaceAlpha', 0.5, 'EdgeColor', 'none');

hold off;