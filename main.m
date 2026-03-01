close all;clear;clc
projectRoot = fileparts(mfilename('fullpath'));
addpath(genpath(projectRoot))
Params = LoadInitialParameters;
%% Select output directory

answer = questdlg('Do you want to save results?', 'Save Results', 'Yes', 'No', 'No');

if strcmp(answer, 'Yes')
    save_results = 1;
else
    save_results = 0;
end

if (save_results)
    outputDir = uigetdir(pwd,'Select output folder');

    if ~exist(outputDir,'dir')
        mkdir(outputDir);
    end

    fprintf('Saving results to: %s\n', outputDir);
end

disp("Select the CT slice file");
[Image_file, InputDir] = uigetfile('*.dcm','Select CT slice');

if isequal(Image_file,0)
    error("No file selected.");
end

slicePath = fullfile(InputDir,Image_file);

sliceName = erase(Image_file,'1-');
sliceName = erase(sliceName,'.dcm');
ImageName = ['Slice #' sliceName];



n = 16;
if (save_results)
    Params.saveDicomDirectory = [outputDir,'\',[ImageName '.Results.contrast.'],num2str(n),''];
    Params.OriginalsaveDicomDirectory = [outputDir,'\',[ImageName '.OriginalResults.contrast.'],num2str(n),''];

    Params.savePngDirectory = [outputDir,'\',[ImageName '.Results.contrast.Png.'],num2str(n)];
    Params.saveCodeDirectory = [outputDir,'\',[ImageName '.Code.contrast.'],num2str(n)];
    Params.OutputDirectory = outputDir;
end
Params.ImageName = ImageName;
Params.TestPreProcessing = 0;
Params.Vrange = [600, 750, 950, 1150, 1350, 1550];

try
    % Read the individual CT slice
    InputImage = dicomread(slicePath);
    ImageInfo = dicominfo(slicePath);

catch
    fprintf('Error reading slice %s.', sliceName);
end

% Convert to appropriate data type
InputImage = int16(InputImage);

% Ensure square image
[row, col] = size(InputImage);
if row ~= col
    InputImage = imresize(InputImage, [max(row,col) max(row,col)]);
end

[ OutputImage ] = CT_CompressHDR( Params, InputImage, ImageInfo, save_results );
OutputImage.Original = InputImage;


figure(str2double(sliceName));
clf
set(gcf,'color','black')
set(gcf,'Units','normalized','Position',[0.1 0.1 0.6 0.8])

% ---- zoom ----
x_start = 90;
x_end   = 410;
y_start = 50;
y_end   = 330;

zoomInput  = InputImage(y_start:y_end, x_start:x_end);
zoomOutput = OutputImage.Final(y_start:y_end, x_start:x_end,:);

% ---- window offset ----
offset = -double(ImageInfo.RescaleIntercept);

bone        = [300+offset 1500];
soft_tissue = [40+offset 400];
lungs       = [-400+offset 1500];

bone_range  = bone(1) + [-bone(2)/2 bone(2)/2];
soft_range  = soft_tissue(1) + [-soft_tissue(2)/2 soft_tissue(2)/2];
lungs_range = lungs(1) + [-lungs(2)/2 lungs(2)/2];

% ---- FULL-BLEED axes ----
set(gcf, 'ToolBar', 'none', 'MenuBar', 'none', 'Color', 'k');

gap = 0.02;
top_margin = 0.08;
w = 0.5 - 1.5*gap;
h = (1 - top_margin) / 2 - 1.5*gap;

ax1 = axes('Position',[gap top_margin + h + gap w h]);
imshow(zoomInput, bone_range);  axis off; 
title('Bone Window','Color','w','FontSize',8);

ax2 = axes('Position',[0.5+gap/2 top_margin + h + gap w h]);
imshow(zoomInput, soft_range);  axis off; 
title('Soft Tissue Window', 'Color','w','FontSize',8);

ax3 = axes('Position',[gap top_margin w h]);
imshow(zoomInput, lungs_range); axis off; 
title('Lungs Window','Color','w','FontSize',8);

ax4 = axes('Position',[0.5+gap/2 top_margin w h]);
imshow(zoomOutput, []);axis off; 
title('HDR','Color','w','FontSize',8);


% ===== SAVE EACH WINDOW TILE AS TIFF =====

if (save_results)

    % create folder once
    tileDir = fullfile(outputDir,'Tiles');
    if ~exist(tileDir,'dir')
        mkdir(tileDir);
    end

    % create clean slice name (slice025 etc.)
    d = dialog('Position',[300 300 280 180],'Name','Tile Name');

    uicontrol('Parent',d,'Style','text','Position',[20 140 240 20], ...
        'String','Do you want to give a unique name?');

    edit_box = uicontrol('Parent',d,'Style','edit','Position',[20 90 240 30], ...
        'String','Enter name here','Enable','off');

    rb_no  = uicontrol('Parent',d,'Style','radiobutton','Position',[20 115 100 20], ...
        'String','No','Value',1, ...
        'Callback',@(s,e) set(edit_box,'Enable','off'));

    rb_yes = uicontrol('Parent',d,'Style','radiobutton','Position',[130 115 100 20], ...
        'String','Yes','Value',0, ...
        'Callback',@(s,e) set(edit_box,'Enable','on'));

    uicontrol('Parent',d,'Position',[90 15 80 25],'String','OK', ...
        'Callback',@(s,e) uiresume(d));

    uiwait(d);

    use_custom = rb_yes.Value;
    user_name  = edit_box.String;
    delete(d);

    if use_custom
        tile_name = sprintf('%s_slice_%03d', user_name, str2double(sliceName));
        outfile = fullfile(outputDir,[user_name '_collage.tif']);

        exportgraphics(gcf, outfile, ...
            'Resolution',600, ...
            'BackgroundColor','black');

    else
        tile_name = sprintf('slice_%03d', str2double(sliceName));
        outfile = fullfile(outputDir,[ImageName '_collage.tif']);

        exportgraphics(gcf, outfile, ...
            'Resolution',600, ...
            'BackgroundColor','black');
    end


    d = dialog('Position',[300 300 250 200],'Name','Save Windows');

    uicontrol('Parent',d,'Style','text','Position',[20 160 200 20],'String','Which windows do you like to save?');

    cb_hdr   = uicontrol('Parent',d,'Style','checkbox','Position',[20 130 200 20],'String','hdr compress');
    cb_soft  = uicontrol('Parent',d,'Style','checkbox','Position',[20 105 200 20],'String','soft tissue window');
    cb_lungs = uicontrol('Parent',d,'Style','checkbox','Position',[20 80  200 20],'String','lungs window');
    cb_bone  = uicontrol('Parent',d,'Style','checkbox','Position',[20 55  200 20],'String','bone window');

    uicontrol('Parent',d,'Position',[80 15 80 25],'String','OK', ...
        'Callback', @(src,evt) uiresume(d));

    uiwait(d);

    save_hdr   = cb_hdr.Value;
    save_soft  = cb_soft.Value;
    save_lungs = cb_lungs.Value;
    save_bone  = cb_bone.Value;

    delete(d);

    % Save according to selection
    if save_bone
        imwrite(mat2gray(zoomInput, bone_range), ...
            fullfile(tileDir, [tile_name '_bone.tif']), ...
            'tif', 'Compression', 'none');
    end

    if save_soft
        imwrite(mat2gray(zoomInput, soft_range), ...
            fullfile(tileDir, [tile_name '_soft.tif']), ...
            'tif', 'Compression', 'none');
    end

    if save_lungs
        imwrite(mat2gray(zoomInput, lungs_range), ...
            fullfile(tileDir, [tile_name '_lungs.tif']), ...
            'tif', 'Compression', 'none');
    end

    if save_hdr
        imwrite(mat2gray(zoomOutput), ...
            fullfile(tileDir, [tile_name '_hdr.tif']), ...
            'tif', 'Compression', 'none');
    end
end