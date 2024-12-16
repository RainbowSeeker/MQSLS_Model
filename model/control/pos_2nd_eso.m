classdef (StrictDefaults) pos_2nd_eso < matlab.System
    % Position Second-Order Extended State Observer
    %
    % NOTE: When renaming the class name untitled, the file name
    % and constructor name must be updated to use the class name.
    %
    % This template includes most, but not all, possible properties, attributes,
    % and methods that you can implement for a System object in Simulink.

    % Public, tunable properties
    properties
        % Position coefficient
        K_p (3, 1)
        % Velocity coefficient
        K_v (3, 1)
    end

    % Public, non-tunable properties
    properties (Nontunable)
        
    end

    % Discrete state properties
    properties (DiscreteState)

    end

    % Pre-computed constants or internal states
    properties (Access = private)
        Z_1
        Z_2
        Z_3

        is_init (1, 1) logical = false
    end

    methods
        % Constructor
        function obj = pos_2nd_eso(varargin)
            % Support name-value pair arguments when constructing object
            setProperties(obj,nargin,varargin{:})
        end
    end

    methods (Access = protected)
        %% Common functions
        function setupImpl(obj, ~, pos, vel)
            % Perform one-time calculations, such as computing constants
            obj.Z_1 = pos;
            obj.Z_2 = vel;
            obj.Z_3 = zeros(size(pos));
            obj.is_init = false;
        end

        function [z1, z2, z3] = stepImpl(obj, acc, pos, vel)
            if ~obj.is_init
                obj.is_init = true;
                obj.Z_1 = pos;
                obj.Z_2 = vel;
                obj.Z_3 = zeros(size(pos));
            else
                obj.Z_1 = obj.Z_1;
                obj.Z_2 = obj.Z_2;
                obj.Z_3 = obj.Z_3;
            end
            sts = getSampleTime(obj);
            dt = sts.SampleTime;
            g = [0; 0; 9.8];

            % Extended state observer
            e_1 = pos - obj.Z_1;
            e_2 = vel - obj.Z_2;
            dot_Z_1 = obj.Z_2 + obj.K_p(1) * e_1;
            dot_Z_2 = acc + obj.Z_3 + g + ...
                      obj.K_p(2) * e_1 + obj.K_v(2) * e_2;
            dot_Z_3 = obj.K_p(3) * e_1 + obj.K_v(3) * e_2;
            
            % Update states
            obj.Z_1 = obj.Z_1 + dt * dot_Z_1;
            obj.Z_2 = obj.Z_2 + dt * dot_Z_2;
            obj.Z_3 = obj.Z_3 + dt * dot_Z_3;

            z1 = obj.Z_1;
            z2 = obj.Z_2;
            z3 = obj.Z_3;
        end

        function resetImpl(obj)
            % Initialize / reset internal or discrete properties
            obj.is_init = false;
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

        function varargout = getOutputSizeImpl(obj)
            % Return size for each output port
            varargout{1} = propagatedInputSize(obj, 1);
            varargout{2} = propagatedInputSize(obj, 1);
            varargout{3} = propagatedInputSize(obj, 1);

            % Example: inherit size from first input port
            % out = propagatedInputSize(obj,1);
        end

        function icon = getIconImpl(obj)
            % Define icon for System block
            icon = "Position\n2nd Order ESO"; % Use class name
            % icon = "My System"; % Example: text icon
            % icon = ["My","System"]; % Example: multi-line text icon
            % icon = matlab.system.display.Icon("myicon.jpg"); % Example: image file icon
        end

        function sts = getSampleTimeImpl(obj)
            % Define sample time type and parameters
            % sts = obj.createSampleTime("Type", "Discrete", "SampleTime", 0.1);
            sts = createSampleTime(obj);
        end

        function varargout = getOutputDataTypeImpl(obj)
            % Return data type for each output port
            % varargout = {'double', 'int32'};
            varargout{1} = propagatedInputDataType(obj, 1);
            varargout{2} = propagatedInputDataType(obj, 1);
            varargout{3} = propagatedInputDataType(obj, 1);
        end

        function varargout = isOutputComplexImpl(obj)
            % Return true for each output port with complex data
            % varargout = {false, true};
            varargout{1} = false;
            varargout{2} = false;
            varargout{3} = false;
        end

        function varargout = isOutputFixedSizeImpl(obj)
            % Return true for each output port with fixed size
            % varargout = {true, true};
            varargout{1} = true;
            varargout{2} = true;
            varargout{3} = true;
        end


    end

    methods (Static, Access = protected)
        %% Simulink customization functions
        function header = getHeaderImpl
            % Define header panel for System block dialog
            header = matlab.system.display.Header(mfilename("class"));
        end

        function group = getPropertyGroupsImpl
            % Define property section(s) for System block dialog
            group = matlab.system.display.Section(mfilename("class"));
        end
    end
end
