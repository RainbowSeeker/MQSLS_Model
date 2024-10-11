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
{'pL', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'vL', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'q', 3, 'double', 'real', 'Sample', 'Fixed', [], [], sprintf('None'), sprintf('unit vector for direction of cable i')}; ...
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
{'q_1', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'q_2', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
{'q_3', 3, 'double', 'real', 'Sample', 'Fixed', [], [], '', ''}; ...
    } ...
  } ...
}'; 

if ~suppressObject 
    % Create bus objects in the MATLAB base workspace 
    Simulink.Bus.cellToObject(cellInfo) 
end 
