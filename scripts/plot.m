

%% payload
x = out.logsout.find('x').Values.Data;
y = out.logsout.find('y').Values.Data;
z = out.logsout.find('z').Values.Data;
% plot3(x, y, z);

q_1 = out.logsout.find('q_1').Values.Data;
plot3(q_1(:,1), q_1(:,2), q_1(:,3));