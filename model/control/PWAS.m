function [result, F_actual] = PWAS(F_trim, F_way, Q, T_min, T_max)
%% Piecewise Wrench Adjustment Strategy (PWAS)
if ~isvector(T_max) || ~isvector(T_min)
    error('max_tension must be vector');
end

N = size(Q, 2);
W = -Q;
A_wrench = [eye(N); -eye(N)] * pinv(W);
b_wrench = [T_max; -T_min];
if WrenchIsValid(F_trim, A_wrench, b_wrench)
% if F_trim in W
    F_fixed = F_trim;
    F_var = F_way;
elseif WrenchIsValid([0;0;F_trim(3)], A_wrench, b_wrench)
% elseif F_trim(3) in W
    F_fixed = [0;0;F_trim(3)];
    F_var = [F_trim(1);F_trim(2);0];
else
% else
    F_fixed = [0;0;0];
    F_var = [0;0;F_trim(3)];
end

alpha = PWAS_LOPT(F_fixed, F_var, A_wrench, b_wrench);

F_actual = F_fixed + alpha * F_var;
result = pinv(Q) * F_actual;
end
%% Algorithm
function alpha = PWAS_LOPT(F_fixed, F_var, A_w, b_w)
A = A_w * F_var;
B = b_w - A_w * F_fixed;

upper = 1;
lower = 0;
for i = 1:length(A)
    if A(i) > 0
        upper = min(upper, B(i) / A(i));
    elseif A(i) < 0
        lower = max(lower, B(i) / A(i));
    end
end

if lower > upper
    error('No Way');
else
    alpha = upper;
end

end

function retval = WrenchIsValid(F_sp, A_w, b_w)
retval = all(A_w * F_sp <= b_w);
end