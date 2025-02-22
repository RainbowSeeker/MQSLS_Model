%% !!! DON'T MODIFY THESE !!!
CONTROL_CONST.g = 9.8;
CONTROL_CONST.dt = 0.05;

CONTROL_EXPORT_VALUE.period = int32(CONTROL_CONST.dt*1e3);
CONTROL_EXPORT = Simulink.Parameter(CONTROL_EXPORT_VALUE);
CONTROL_EXPORT.CoderInfo.StorageClass = 'ExportedGlobal';

CONTROL_PARAM_VALUE.MASS_LOAD = 1; % kg
CONTROL_PARAM_VALUE.MASS_UAV = 1.5; % kg
CONTROL_PARAM_VALUE.CABLE_LEN = 1; % m
% CONTROL_PARAM_VALUE.RHO = [0.5  -0.5 -0.5  
%                            0    0.4  -0.4
%                            -0.1 -0.1 -0.1];

CONTROL_PARAM_VALUE.TENSION_MIN = 0; % N
CONTROL_PARAM_VALUE.TENSION_MAX = 20; % N

CONTROL_PARAM_VALUE.ESO_PL = [3 5 10];
CONTROL_PARAM_VALUE.ESO_VL = [0 0 0];
CONTROL_PARAM_VALUE.ESO_PI = [3 5 10];
CONTROL_PARAM_VALUE.ESO_VI = [0 20 30];

CONTROL_PARAM_VALUE.KP = 0.2; % Kp
CONTROL_PARAM_VALUE.KPI = 0.05; % Kp_i
CONTROL_PARAM_VALUE.KV = 1; % Kv
% CONTROL_PARAM_VALUE.KR = 1; % KR
% CONTROL_PARAM_VALUE.KOMEGA = 2; % Komega
CONTROL_PARAM_VALUE.KQ = 0.5; % Kq 0.5
CONTROL_PARAM_VALUE.KW = 3; % Kw 2
CONTROL_PARAM_VALUE.KQI = 0; % Kq_i 2
% Export
CONTROL_PARAM = Simulink.Parameter(CONTROL_PARAM_VALUE);
CONTROL_PARAM.CoderInfo.StorageClass = 'ExportedGlobal';