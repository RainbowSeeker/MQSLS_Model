function margin = margin_lp(center, W, T_min, T_max)
%% margin_lp
N = size(W, 2);

A_wrench = [eye(N); -eye(N)] * pinv(W);
b_wrench = [T_max; -T_min];

% minimize distance
margin = min((b_wrench - A_wrench * center) ./ vecnorm(A_wrench, 2, 2));
end