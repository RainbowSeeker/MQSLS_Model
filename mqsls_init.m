%% version
version = 'v0.0.2';

%% load
load('prj_default_config.mat');
run('bus_export');
run('control_init.m');
run('plant_init.m');