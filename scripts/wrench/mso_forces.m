function [best_result, best_radius, best_exitflag] = mso_forces(center, T_min, T_max)
%% MultiStart Optimize Forces
% INPUT
% center (3x1): 球心
% T_min (Nx1): 最小张力
% T_max (Nx1): 最大张力

if ~isvector(T_max) || ~isvector(T_min)
    error('max_tension must be vector');
end

N = length(T_max);
%% Solver
% 目标函数
function obj_val = objective(W, p, N, T_max, T_min)
    W = reshape(W, [3, length(W) / 3]);
    W = W ./ vecnorm(W, 2, 1);

    A_wrench = [eye(N); -eye(N)] * pinv(W);
    b_wrench = [T_max; -T_min];

    distances = (b_wrench - A_wrench * p) ./ vecnorm(A_wrench, 2, 2);

    % 返回最小距离（负号用于最大化）
    obj_val = -min(distances);
end
% 非线性约束：单位向量约束
function [c, ceq, gradc, gradceq] = constraint(W)
    c = [];
    ceq = sum(reshape(W, 3, length(W) / 3).^2, 1) - 1;
    
    if nargout > 2
        gradc = [];
        gradceq = zeros(length(W), length(W) / 3);
        for idx = 1:length(W) / 3
            gradceq(3*idx-2:3*idx, idx) = 2 * W(3*idx-2:3*idx);
        end
    end
end

% 不等式约束
psi = deg2rad(360) / N * (0:N-1)';
range = deg2rad(180 / N);
qxy_ub = [sin(psi + range) -cos(psi + range) zeros(N, 1)];
qxy_lb = [sin(psi - range) -cos(psi - range) zeros(N, 1)];
A = zeros([N * 2, N * 3]);
for i = 1:N
    A(i, 3*i-2:3*i) = -qxy_ub(i, :);
    A(i + N, 3*i-2:3*i) = qxy_lb(i, :);
end
b = zeros(N * 2, 1);

% 等式约束    
Aeq = [];
beq = [];

% 上下限
ub = repmat([1 1 0], 1, N);
lb = -ones(1, 3 * N);

% 目标函数
f_objective = @(W) objective(W, center, N, T_max, T_min);

% 优化选项
options = optimoptions('fmincon', 'Display', 'off', ...
                        'Algorithm', 'sqp', 'SpecifyConstraintGradient', true, ...
                        'MaxIterations', 100);

%% MultiStart
theta_list = deg2rad([10, 20, 30, 40, 50, 60, 70]);
q = zeros([3 * N, 1]);

best_radius = -nan;
best_result = zeros(size(q));
best_exitflag = 0;

for i = 1:length(theta_list)
    for j = 1:N
      q(3*j-2:3*j) = [-cos(psi(j)) * cos(theta_list(i)) -sin(psi(j)) * cos(theta_list(i)) sin(theta_list(i))];
    end

    % 优化求解
    [result, maxfval, exitflag, output] = fmincon(f_objective, -q, A, b, Aeq, beq, ...
                        lb, ub, @(W) constraint(W), options);

    % 输出结果
    % disp_result(i, result, maxfval, exitflag, output);

    % 保存最优结果
    if ~isfinite(best_radius) || best_radius < -maxfval
        best_radius = -maxfval;
        best_result = -result;
        best_exitflag = exitflag;
    end
end
end

function disp_result(index, result, maxfval, exitflag, output)
    res = reshape(result, 3, 3);
    res = res ./ vecnorm(res, 2, 1);
    angle = zeros(2, 3);
    for i = 1:3
        angle(:, i) = [atan(res(3, i) / norm(res(1:2, i))) atan2(res(2, i), res(1, i))]';
    end
    angle_str = num2str(rad2deg(angle));

    disp(['第', num2str(index), '次结果：']);
    fprintf(['\tIterCnt:\t\t', num2str(output.iterations), '\n']);
    fprintf(['\tMargin:\t\t', num2str(-maxfval), '\n']);
    fprintf(['\texitflag:\t', num2str(exitflag), '\n']);
    fprintf(['\tResult:\n\t\t', angle_str(1, :), '\n\t\t', angle_str(2, :), '\n']);
end