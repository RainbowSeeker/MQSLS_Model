F_way = [12; 0; -2];
T_min = 5 * ones(3, 1);
T_max = 15 * ones(3, 1);

[center, radius, Q] = P2_wrench_space([5, 6, 8, 7]);

[~, F_actual] = PWAS(center, F_way, reshape(Q, 3, 3), T_min, T_max);

X = [-1.5, center(2), F_actual(2)];
Y = [1.5 , center(1), F_actual(1)];
Z = [-7.5, center(3), F_actual(3)];

U = [center(2), F_actual(2), center(2) + F_way(2)] - X;
V = [center(1), F_actual(1), center(1) + F_way(1)] - Y;
W = [center(3), F_actual(3), center(3) + F_way(3)] - Z;

color = ['k';
         'g';
         'r'];
for i = 1:3
    quiver3(X(i), Y(i), Z(i), U(i), V(i), W(i), 'off',...
            'LineWidth', 2.5, 'MaxHeadSize', 1, 'Color', color(i));
end

zlim([-23, -7]);
