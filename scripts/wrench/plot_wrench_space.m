function plot_wrench_space(W, T_min, T_max, varargin)
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
    % W(3, :) = -W(3, :);
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
    % [K, ~] = convhull(X, Y, Z);
    % 绘制凸包
    % trisurf(K, X, Y, Z, 'FaceColor', 'c','FaceAlpha', 0.5);
    % % 绘制点集
    plot3(X, Y, Z, 'bo', 'MarkerSize', 8, 'MarkerFaceColor','w'); 
    view(3);
    edges_visible = [
        1 2; 1 3; 2 4; 3 4; 2 6; 
        4 8; 6 8; 3 7; 7 8;
    ];

    edges_invisible = [
        5 7; 1 5; 5 6;
    ];
    
    % edges_visible = [
    %     1 2; 1 3; 2 4; 3 4; 2 6; 
    %     4 8; 6 8; 1 5; 5 6;
    % ];
    % 
    % edges_invisible = [
    %     5 7; 3 7; 7 8;
    % ];
    if length(varargin) >= 1 && varargin{1}
        for i = 1:size(edges_invisible, 1)
            plot3([X(edges_invisible(i, 1)), X(edges_invisible(i, 2))], ...
                  [Y(edges_invisible(i, 1)), Y(edges_invisible(i, 2))], ...
                  [Z(edges_invisible(i, 1)), Z(edges_invisible(i, 2))], '--', 'LineWidth', 2);
        end
    else
        edges_visible = [edges_visible; edges_invisible];
    end

    for i = 1:size(edges_visible, 1)
        plot3([X(edges_visible(i, 1)), X(edges_visible(i, 2))], ...
              [Y(edges_visible(i, 1)), Y(edges_visible(i, 2))], ...
              [Z(edges_visible(i, 1)), Z(edges_visible(i, 2))], '-', 'LineWidth', 2);
    end
    
    if length(varargin) >= 2
        patch('Vertices', Wa', 'Faces', varargin{2}, 'FaceColor', 'cyan', 'EdgeColor', 'none',...
                'FaceAlpha', 0.4);
    end
    
    xlabel('Y');
    ylabel('X');
    zlabel('Z');
    set(gca, 'ZDir', 'reverse');

    
    axis equal;
    grid on;
    
    view(3);
end

function A = generateAlphaMatrix(n)
    A = zeros(n, 2^n);
    
    for i = 1:n
        % 生成重复序列来构造每一行
        A(i, :) = repmat([zeros(1, 2^(n-i)) ones(1, 2^(n-i))], 1, 2^(i-1));
    end
end
