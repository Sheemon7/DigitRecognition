function prepare_load_panel(load_panel, new_game_callback, save_game_callback, load_game_callback)
% PREPARE_LOAD_PANEL initializes panel, where loading process takes place.
% Inputs:
%   load_panel = handle of the panel, where the components will be placed
%   new_game_callback = callback to set brand new network to workspace
%   save_game_callback = callback to save current network
%   load_game_callback = callback to load current network

% edit text with path of the file
path_text = uicontrol('Parent', load_panel, ...
    'Style', 'edit', ...
    'Units', 'normalized', ...
    'String', fullfile(pwd, 'test.mat'), ...
    'Callback', @(src, ~, ~) check_file_exists(src.String));
e = path_text.Extent;
path_text.Position = [0.05 1/3 - e(4) / 2 0.9 e(4)];

browse_button = uicontrol('Parent', load_panel, ...
    'Style', 'pushbutton', ...
    'Units', 'normalized', ...
    'String', 'Browse (load)', ...
    'Callback', @browse_function);
e = browse_button.Extent;
browse_button.Position = [1/2 2/3 - e(4) / 2 1/5 e(4)];

warning_text = uicontrol('Parent', load_panel, ...
    'Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0 0 0 0], ...
    'String', '', ...
    'BackgroundColor', 'white', ...
    'ForegroundColor', 'blue');

%% AUX FUNCTIONS

    function ret = check_file_exists(fullname)
        % checks whether given file exists and sets corresponding actions
        ret = exist(fullname, 'file') == 2;
        if ~ret
            warning_text.String = 'Selected file doesn''t exist';
            e = warning_text.Extent;
            warning_text.Position = [0.05 1/6 - e(4) / 1.5 0.9 e(4)];
        else
            warning_text.String = 'Selected file exists';
            e = warning_text.Extent;
            warning_text.Position = [0.05 1/6 - e(4) / 1.5 0.9 e(4)];
        end
    end
        
    function browse_function(~, ~)
        % opens dialog for file loading
        [fname , fpath] = uigetfile('*.mat','Select the data file');
        fullname = fullfile(fpath, fname);
        if fname ~= 0
            path_text.String = fullname;
            load_game_callback(fullname);
        end
    end

% prepare "New" button
new_button = uicontrol('Parent', load_panel, ...
    'Style', 'pushbutton', ...
    'Units', 'normalized', ...
    'String', 'New', ...
    'Callback', @(~, ~) new_game_callback());
e = new_button.Extent;
new_button.Position = [0.05 2/3 - e(4) / 2 1/5 e(4)];

% prepare "Save" button
save_button = uicontrol('Parent', load_panel, ...
    'Style', 'pushbutton', ...
    'Units', 'normalized', ...
    'String', 'Save (to path below)', ...
    'Callback', @(~, ~) save_game_callback(path_text.String));
e = save_button.Extent;
save_button.Position = [3/4 2/3 - e(4) / 2 1/5 e(4)];
end

