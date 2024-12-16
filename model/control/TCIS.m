function [result, F_actual] = TCIS(Q, F_sp, min_tension, max_tension)
%% Tension-Constrained Iterative Solver
tolerance = 1e-5;
found = zeros(size(Q, 2), 1, 'logical');
result = zeros(size(Q, 2), 1, 'double');
F_d = F_sp;
Q_new = Q;
while true
    vu = pinv(Q_new) * F_d;
    is_valid = true;
    for i = 1:size(vu, 1)
        if found(i)
            continue
        end
        if -vu(i) < min_tension - tolerance
            vu(i) = -min_tension;
            is_valid = false;
            break;
        elseif -vu(i) > max_tension + tolerance
            vu(i) = -max_tension;
            is_valid = false;
            break;
        end
    end
    if is_valid
        for j = 1:size(found, 1)
            if ~found(j)
                result(j) = vu(j);
            end
        end
        break;
    else
        found(i) = i;
        result(i) = vu(i);
    end

    % update F && Q
    F_d = [0; 0; F_sp(3)];
    for j = 1:size(found, 1)
        if found(j)
            F_d = F_d - result(j) * Q(:, j);
        end
    end 
    Q_new(:, i) = -[F_sp(1); F_sp(2); 0];
end

F_actual = Q * result;
end