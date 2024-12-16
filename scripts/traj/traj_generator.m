classdef (StrictDefaults) traj_generator < matlab.System
    % Generate expected trajectory.
    %
    % NOTE: When renaming the class name untitled4, the file name
    % and constructor name must be updated to use the class name.
    %
    % This template includes most, but not all, possible properties, attributes,
    % and methods that you can implement for a System object in Simulink.
    % Public, tunable properties
    properties
        
    end

    % Public, non-tunable properties
    properties (Nontunable)
        %type
        traj_type string {mustBeMember(traj_type, {'circle', 'line'})} = 'line';
    end

    % Discrete state properties
    properties (DiscreteState)

    end

    % Pre-computed constants or internal states
    properties (Access = private)
        cb
    end

    methods
        % Constructor
        function obj = traj_generator(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods (Access = protected)
        %% Common functions
        function setupImpl(obj)
            % Perform one-time calculations, such as computing constants
            % choose the trajectory type
            switch obj.traj_type
                case 'circle'
                    obj.cb = @traj_circle;
                case 'line'
                    obj.cb = @traj_line;
                otherwise
                    obj.cb = @traj_generator.traj_none;
            end
        end

        function [pos, vel, acc] = stepImpl(obj, time)
            % Implement algorithm. Calculate y as a function of input u and
            % internal or discrete states.
            [pos, vel, acc] = obj.cb(time);
        end

        function resetImpl(obj)
            % Initialize / reset internal or discrete properties
        end

        %% Backup/restore functions
        function s = saveObjectImpl(obj)
            % Set properties in structure s to values in object obj

            % Set public properties and states
            s = saveObjectImpl@matlab.System(obj);

            % Set private and protected properties
            %s.myproperty = obj.myproperty;
        end

        function loadObjectImpl(obj,s,wasLocked)
            % Set properties in object obj to values in structure s

            % Set private and protected properties
            % obj.myproperty = s.myproperty; 

            % Set public properties and states
            loadObjectImpl@matlab.System(obj,s,wasLocked);
        end

        %% Simulink functions
        function ds = getDiscreteStateImpl(obj)
            % Return structure of properties with DiscreteState attribute
            ds = struct([]);
        end

        function num = getNumInputsImpl(obj)
            % Define total number of inputs for system with optional inputs
            num = 1;
        end

        function num = getNumOutputsImpl(obj)
            % Define total number of outputs for system with optional outputs
            num = 3;
        end

        function varargout = getOutputSizeImpl(obj)
            % Return size for each output port
            varargout{1} = [3 1];
            varargout{2} = [3 1];
            varargout{3} = [3 1];

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function varargout = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            varargout{1} = "double";
            varargout{2} = "double";
            varargout{3} = "double";

            % Example: inherit data type from first input port
            % out = propagatedInputDataType(obj,1);
        end

        function varargout = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            varargout{1} = false;
            varargout{2} = false;
            varargout{3} = false;

            % Example: inherit complexity from first input port
            % out = propagatedInputComplexity(obj,1);
        end

        function varargout = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            varargout{1} = true;
            varargout{2} = true;
            varargout{3} = true;

            % Example: inherit fixed-size status from first input port
            % out = propagatedInputFixedSize(obj,1);
        end

        function icon = getIconImpl(obj)
            % Define icon for System block
            icon = ["Trajectory","Generator"]; % Use class name
            % icon = "My System"; % Example: text icon
            % icon = ["My","System"]; % Example: multi-line text icon
            % icon = matlab.system.display.Icon("myicon.jpg"); % Example: image file icon
        end
    end

    methods (Static, Access = protected)
        %% Simulink customization functions
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header(mfilename('class'));
        end

        function group = getPropertyGroupsImpl
            % Define property section(s) for System block dialog
            group = matlab.system.display.Section(mfilename('class'));
        end

        function [pos, vel, acc] = traj_none(~)
            pos = [0; 0; -5];
            vel = [0; 0; 0];
            acc = [0; 0; 0];
        end
    end
end
