function draw_mqsls(load_position, uav_position, uav_euler)
    % load_position     - 负载位置坐标 [x,y,z]
    % uav_position      - 3 个 UAV 位置坐标 (3 x 3)
    % uav_euler         - 3 个 UAV 欧拉角 (3 x 3)

    % figure;
    
    draw_drone(uav_position(1, :), uav_euler(1, :), '#0072BD');
    draw_drone(uav_position(2, :), uav_euler(2, :), '#D95319');
    draw_drone(uav_position(3, :), uav_euler(3, :), '#A2142F');
    
    draw_cube(load_position, [.2, .2, .2], '#EDB120');
    
    for i = 1:3
        X_conn = [load_position(1), uav_position(i, 1)];
        Y_conn = [load_position(2), uav_position(i, 2)];
        Z_conn = [load_position(3), uav_position(i, 3)];
        plot3(X_conn, Y_conn, Z_conn, 'k', 'LineWidth', 2);
    end
end

function draw_drone(position, euler, color)
    % 绘制带姿态的四旋翼无人机
    % 输入参数：
    %   position - 三维位置坐标 [x,y,z]
    %   eul      - 欧拉角 [横滚, 俯仰, 偏航]（单位：度）

    hold on;
    axis equal;
    grid on;
    view(3);
    xlabel('X'); ylabel('Y'); zlabel('Z');
    title('四旋翼无人机3D模型');

    % ======================== 无人机参数 ========================
    arm_length = 0.3;     % 机臂长度（中心到旋翼的距离）
    body_radius = 0.1;    % 中心机身半径
    prop_radius = 0.1;    % 螺旋桨半径
    prop_height = 0.05;   % 螺旋桨厚度
    
    % ======================== 姿态旋转矩阵 ========================
    % 将角度转换为弧度 (Z-Y-X旋转顺序)
    roll = deg2rad(euler(1));
    pitch = deg2rad(euler(2));
    yaw = deg2rad(euler(3));
    
    % 各轴旋转矩阵
    Rx = [1 0 0; 
          0 cos(roll) -sin(roll);
          0 sin(roll) cos(roll)];
    
    Ry = [cos(pitch) 0 sin(pitch);
           0 1 0;
          -sin(pitch) 0 cos(pitch)];
    
    Rz = [cos(yaw) -sin(yaw) 0;
          sin(yaw) cos(yaw) 0;
          0 0 1];
    
    R = Rz * Ry * Rx;  % 组合旋转矩阵

    % ======================== 坐标变换函数 ========================
    transform = @(p)( R * p' + position' )'; % 旋转后平移

    % ======================== 绘制中心机身 ========================
    [X,Y,Z] = sphere(20);
    points = [X(:), Y(:), Z(:)] * body_radius;
    rotated_points = transform(points);
    
    surf(reshape(rotated_points(:,1), size(X)),...
         reshape(rotated_points(:,2), size(Y)),...
         reshape(rotated_points(:,3), size(Z)),...
         'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none');

    % ======================== 绘制机臂 ========================
    arm_dirs = arm_length * [1 0 0; -1 0 0; 0 1 0; 0 -1 0];
    for i = 1:4
        end_point = transform(arm_dirs(i,:));
        plot3([position(1), end_point(1)],...
              [position(2), end_point(2)],...
              [position(3), end_point(3)],...
              'LineWidth', 3, 'Color', [0.2 0.2 0.2])
    end

    % ======================== 绘制螺旋桨 ========================
    theta = linspace(0, 2*pi, 50);
    z_prop = linspace(0, prop_height, 20)';
    
    for i = 1:4
        % 获取当前机臂参数
        arm_dir = arm_dirs(i,:);
        
        % 生成加强型侧面网格
        [T,Z] = meshgrid(theta, z_prop);
        X_local = prop_radius * cos(T);
        Y_local = prop_radius * sin(T);
        
        % 坐标变换（局部->世界）
        points = [X_local(:), Y_local(:), Z(:)] + arm_dir;
        transformed = transform(points);
        
        % 重组网格坐标
        X_rot = reshape(transformed(:,1), size(X_local));
        Y_rot = reshape(transformed(:,2), size(Y_local));
        Z_rot = reshape(transformed(:,3), size(Z));
        
        % 绘制加强侧面
        surf(X_rot, Y_rot, Z_rot, ...  
            'FaceColor', color, ...
            'EdgeColor', color,...
            'LineWidth', 3.5,...
            'FaceAlpha', 0.5,...
            'EdgeAlpha', 0.5);
    end
end

function draw_cube(center, dimensions, color)
    % center: 立方体上表面的中心点 (3x1 向量)
    % dimensions: 长宽高 (1x3 向量)

    % 提取中心点和维度
    x_center = center(1);
    y_center = center(2);
    z_center = center(3);
    
    length = dimensions(1);   % 长度
    width = dimensions(2);    % 宽度
    height = dimensions(3);   % 高度

    % 计算立方体的八个顶点
    vertices = [
        x_center - length/2, y_center - width/2, z_center;  % 前下左
        x_center + length/2, y_center - width/2, z_center;  % 前下右
        x_center + length/2, y_center + width/2, z_center;  % 前上右
        x_center - length/2, y_center + width/2, z_center;  % 前上左
        x_center - length/2, y_center - width/2, z_center - height;  % 后下左
        x_center + length/2, y_center - width/2, z_center - height;  % 后下右
        x_center + length/2, y_center + width/2, z_center - height;  % 后上右
        x_center - length/2, y_center + width/2, z_center - height;  % 后上左
    ];

    % 定义立方体的面
    faces = [
        1 2 3 4;  % 前面
        5 6 7 8;  % 后面
        1 2 6 5;  % 底面
        4 3 7 8;  % 顶面
        1 4 8 5;  % 左面
        2 3 7 6;  % 右面
    ];

    patch('Vertices', vertices, 'Faces', faces, 'FaceColor', color, 'EdgeColor', 'black');
    
    axis equal;
    grid on;
    view(3);
end