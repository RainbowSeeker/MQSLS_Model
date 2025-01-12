%% Preprocess
project = matlab.project.currentProject;
if ~isempty(project)
    projectRoot = project.RootFolder;
else
    error('Invalid');
end

saveFolder = projectRoot + '/asset/';
targetFolder = '~/Documents/毕业/小论文/conf_paper/image';
%% Plot & Save in turn
plot_list = [
    "P1_tension_space";
    "P2_wrench_space";
    "P3_margin";
    "P4_PWAS";
];

close all;

run_every(saveFolder, plot_list);

copyAllPDFs(saveFolder, targetFolder);

function run_every(folder, list)
    for idx = 1:size(list, 1)
        eval(list(idx, :));
        exportgraphics(gcf, fullfile(folder, list(idx, :) + '.pdf'), 'ContentType', 'vector', 'Resolution', 600);
        close;
    end
end

function copyAllPDFs(sourceFolder, targetFolder)
    % 检查源文件夹是否存在
    if ~isfolder(sourceFolder)
        error('源文件夹不存在：%s', sourceFolder);
    end

    % 如果目标文件夹不存在，则创建
    if ~isfolder(targetFolder)
        mkdir(targetFolder);
    end

    % 获取所有 .pdf 文件
    pdfFiles = dir(fullfile(sourceFolder, '*.pdf'));

    % 如果没有找到 .pdf 文件
    if isempty(pdfFiles)
        disp('没有找到 .pdf 文件。');
        return;
    end

    % 遍历并复制文件
    for k = 1:length(pdfFiles)
        sourceFile = fullfile(sourceFolder, pdfFiles(k).name);
        targetFile = fullfile(targetFolder, pdfFiles(k).name);
        
        % 尝试复制文件
        try
            copyfile(sourceFile, targetFile);
            fprintf('已成功复制: %s\n', pdfFiles(k).name);
        catch ME
            fprintf('文件复制失败: %s\n错误信息: %s\n', pdfFiles(k).name, ME.message);
        end
    end

    disp('文件复制完成！');
end