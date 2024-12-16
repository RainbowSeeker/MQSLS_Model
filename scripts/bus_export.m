function cellInfo = bus_export(varargin) 
% BUS_EXPORT returns a cell array containing bus object information 
% 
% Optional Input: 'false' will suppress a call to Simulink.Bus.cellToObject 
%                 when the MATLAB file is executed. 
% The order of bus element attributes is as follows:
%   ElementName, Dimensions, DataType, Complexity, SamplingMode, DimensionsMode, Min, Max, DocUnits, Description 

suppressObject = false; 
if nargin == 1 && islogical(varargin{1}) && varargin{1} == false 
    suppressObject = true; 
elseif nargin > 1 
    error('Invalid input argument(s) encountered'); 
end 

cellInfo = { ... 
  { ... 
    'Control_In_Bus', ... 
    '', ... 
    '', ... 
    'Auto', ... 
    '-1', ... 
    '0', {... 
{'timestamp', 1, 'uint32', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'vforce', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', sprintf('Used by 6dof')}; ...
{'q_sp', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', sprintf('Used by 3dof')}; ...
{'q', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', sprintf('unit vector for direction of cable i')}; ...
{'w', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'ai_sp', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'pi', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'vi', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
    } ...
  } ...
  { ... 
    'Control_Out_Bus', ... 
    '', ... 
    '', ... 
    'Auto', ... 
    '-1', ... 
    '0', {... 
{'timestamp', 1, 'uint32', 'real', 'Sample', 'Fixed', [], [], sprintf('ms'), ''}; ...
{'w_4', 4, 'double', 'real', 'Sample', 'Fixed', [], [], sprintf('rad/s'), sprintf('4 rotors speed [rad/s]')}; ...
    } ...
  } ...
  { ... 
    'Payload_In_Bus', ... 
    '', ... 
    '', ... 
    'Auto', ... 
    '-1', ... 
    '0', {... 
{'timestamp', 1, 'uint32', 'real', 'Sample', 'Fixed', [], [], sprintf('ms'), ''}; ...
{'force', 3, 'double', 'real', 'Sample', 'Fixed', [], [], sprintf('N'), sprintf('force on the cable')}; ...
{'moment', 3, 'double', 'real', 'Sample', 'Fixed', [], [], sprintf('N*m'), sprintf('moment on the cable')}; ...
    } ...
  } ...
  { ... 
    'Payload_Out_Bus', ... 
    '', ... 
    '', ... 
    'Auto', ... 
    '-1', ... 
    '0', {... 
{'timestamp', 1, 'uint32', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'pL', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'vL', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'p_1', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'p_2', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'p_3', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'v_1', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'v_2', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'v_3', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
    } ...
  } ...
  { ... 
    'TrajCmd_In_Bus', ... 
    '', ... 
    '', ... 
    'Auto', ... 
    '-1', ... 
    '0', {... 
{'pos_sp', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'vel_sp', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'acc_ff', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
    } ...
  } ...
}'; 

if ~suppressObject 
    % Create bus objects in the MATLAB base workspace 
    Simulink.Bus.cellToObject(cellInfo) 
end 
