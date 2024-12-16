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
q = zeros([3 3]);
for i = 1:3
  q(:, i) = [-cos(psi(i)) * cos(theta(i)) -sin(psi(i)) * cos(theta(i)) sin(theta(i))];
end

plot_wrench_space(q, 1, 10);

function plot_wrench_space(Q, minTension, maxTension)
    % 函数输入: 
    % q: 方向向量矩阵，每一列代表一个力
    % minTension: 最小张力
    % maxTension: 最大张力
    if minTension >= maxTension
        error("minForce must be smaller than maxForce!");
    end

    %% 3dim convex hull
    W = Q;
    num = size(W, 2); % num of uavs
    deltaT = maxTension - minTension;
    alpha = generateAlphaMatrix(num);
    Tmin= minTension * ones(num, 1);
    Wa = W * diag(deltaT * ones(num, 1)) * alpha + W * Tmin * ones(1, 2^num);
    
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
    % print('asset/force_area', '-dpng', '-r600');
end

function A = generateAlphaMatrix(n)
    A = zeros(n, 2^n);
    
    for i = 1:n
        % 生成重复序列来构造每一行
        A(i, :) = repmat([zeros(1, 2^(n-i)) ones(1, 2^(n-i))], 1, 2^(i-1));
    end
end
