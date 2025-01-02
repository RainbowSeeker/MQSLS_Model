function margin = margin_lp(center, W, T_min, T_max)
%% Preprocess
N = size(W, 2);

% A_alpha = zeros([N * 2, N]);
% b_alpha = zeros([N * 2, 1]);
% for i = 1:N
%     A_alpha(2*i-1:2*i, i) = [1; -1];
%     b_alpha(2*i-1:2*i) = [1; 0];
% end
% deltaT = T_max - T_min;
% A_wrench = A_alpha * pinv(W * diag(deltaT));
% b_wrench = A_alpha * pinv(diag(deltaT)) * T_min + b_alpha;

A_wrench = [eye(N); -eye(N)] * pinv(W);
b_wrench = [T_max; -T_min];

% minimize distance
margin = min((b_wrench - A_wrench * center) ./ vecnorm(A_wrench, 2, 2));
end