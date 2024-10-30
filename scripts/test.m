
angular_velocity = [1 2 3]';
current_vector = [-cos(deg2rad(-120)) * cos(deg2rad(60)) -sin(deg2rad(-120)) * cos(deg2rad(60)) sin(deg2rad(60))]';

% cross(current_vector, cross(current_vector, angular_velocity))
skew(current_vector)*skew(current_vector)*angular_velocity

function skew_matrix = skew(vector)
    % Create a skew-symmetric matrix from a vector
    skew_matrix = [0, -vector(3), vector(2);
                   vector(3), 0, -vector(1);
                   -vector(2), vector(1), 0];
end