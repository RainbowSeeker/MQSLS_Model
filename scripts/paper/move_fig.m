screens = get(0, 'MonitorPositions');  % 获取所有屏幕的位置
mainScreen = screens(1, :);            % 主屏幕的位置信息
set(gcf, 'Position', [mainScreen(1) + 100, mainScreen(2) + 100, 600, 400]);
movegui('center')