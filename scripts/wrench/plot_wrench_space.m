function plot_wrench_space(W, T_min, T_max)
    % 函数输入: 
    % W: 方向向量矩阵，每一列代表一个力 3XN
    % T_min: 最小张力 3X1
    % T_max: 最大张力 3X1
    if any(T_min >= T_max)
        error("minForce must be smaller than maxForce!");
    end

    %% 3dim convex hull
    tmp = W(1, :);
    W(1, :) = W(2, :);
    W(2, :) = tmp;
    W(3, :) = -W(3, :);
    num = size(W, 2); % num of uavs
    deltaT = T_max - T_min;
    alpha = generateAlphaMatrix(num);
    % See Ep(14).
    W = W ./ vecnorm(W, 2, 1);
    Wa = W * diag(deltaT) * alpha + W * T_min * ones(1, 2^num);
    
    % get convex points
    X = Wa(1, :);
    Y = Wa(2, :);
    Z = Wa(3, :);
    
    %% Plot convex hull
    figure;
    hold on;

    % 计算三维凸包
    [K, V] = convhull(X, Y, Z);
    % 绘制凸包
    trisurf(K, X, Y, Z, 'FaceColor', 'cyan', 'FaceAlpha', 0.5);
    % 绘制点集
    plot3(X, Y, Z, 'ro', 'MarkerSize', 6, 'MarkerFaceColor', 'r'); 
    title('3 Dim Convex Hull');

    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    
    axis equal;
    grid on;
    
    view(3);
    
    hold off;
end

function A = generateAlphaMatrix(n)
    A = zeros(n, 2^n);
    
    for i = 1:n
        % 生成重复序列来构造每一行
        A(i, :) = repmat([zeros(1, 2^(n-i)) ones(1, 2^(n-i))], 1, 2^(i-1));
    end
end
