%% version
version = 'v0.0.2';
prj_path = pwd;

%% load
load('prj_default_config.mat');
run('bus_export');
run('control_init.m');
run('plant_init.m');