len = 10;

% 立方体的8个顶点坐标
vertices = [
    0 0 0;  % 顶点 1
    1 0 0;  % 顶点 2
    1 1 0;  % 顶点 3
    0 1 0;  % 顶点 4
    0 0 1;  % 顶点 5
    1 0 1;  % 顶点 6
    1 1 1;  % 顶点 7
    0 1 1;  % 顶点 8
];
vertices = len * vertices;

% 立方体的边的连接关系
edges_visible = [
    1 2; 1 4; 1 5; 2 6; 4 8; 
    5 6; 5 8; 6 7; 7 8;
];

edges_invisible = [
    2 3; 3 4; 3 7; % 这些边是不可见的，需要用虚线表示
];

% 绘制可见边
figure;
hold on;

for i = 1:size(edges_visible, 1)
    plot3([vertices(edges_visible(i, 1), 1), vertices(edges_visible(i, 2), 1)], ...
          [vertices(edges_visible(i, 1), 2), vertices(edges_visible(i, 2), 2)], ...
          [vertices(edges_visible(i, 1), 3), vertices(edges_visible(i, 2), 3)], '-', 'LineWidth', 2, 'Color', "#0072BD");
end

% 绘制不可见边（虚线）
for i = 1:size(edges_invisible, 1)
    plot3([vertices(edges_invisible(i, 1), 1), vertices(edges_invisible(i, 2), 1)], ...
          [vertices(edges_invisible(i, 1), 2), vertices(edges_invisible(i, 2), 2)], ...
          [vertices(edges_invisible(i, 1), 3), vertices(edges_invisible(i, 2), 3)], '--', 'LineWidth', 2, 'Color', "#0072BD");
end

% 设置坐标轴
axis equal;
grid on;
xlabel('$T_1$', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('$T_2$', 'Interpreter', 'latex', 'FontSize', 14);
zlabel('$T_3$', 'Interpreter', 'latex', 'FontSize', 14);
% xlimit([0 12]);
view(3);