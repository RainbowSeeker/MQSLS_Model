function save_to_mat(varargin)

defaultPath = [evalin('base', 'prj_path'), '/asset']; % my workspace

[filename, pathname] = uiputfile({'*.mat', 'MAT-File (*.m)'}, 'Select File For Save As', defaultPath);

if isequal(filename, 0) || isequal(pathname, 0)
    return;
end

fullname = fullfile(pathname, filename);

if ~isempty(varargin)
    out.logsout = varargin{1};
else
    out.logsout = evalin('base', 'ds');
end

save(fullname, 'out');

end