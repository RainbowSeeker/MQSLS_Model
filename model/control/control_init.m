
CONTROL_PARAM_VALUE.MASS_LOAD = 0.2; % kg



% Export
CONTROL_PARAM = Simulink.Parameter(CONTROL_PARAM_VALUE);
CONTROL_PARAM.CoderInfo.StorageClass = 'ExportedGlobal';