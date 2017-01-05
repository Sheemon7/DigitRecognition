function run_gui(network_create_handle)
% RUN_GUI is the main function of whole program, it is ran at the beginning
% and it runs for the whole time.
% Inputs:
%     network_create_handle = handle for new network creation

% init every gui element (call corresponding methods)
network_handle = 0;
new_network();
hFig = create_fig();
[draw_panel, load_panel, learn_panel, res_panel] = create_main_panels(hFig);
[~, getResultsCallback, eraseCallback] = draw_digit(28, hFig, draw_panel);
hTextResult = prepare_results_text(res_panel);
prepare_load_panel(load_panel, @new_network, @save_game, @load_game);
[spinner, epoch_plot, epoch_ax] = prepare_learn_panel(learn_panel, @learn_network, ...
    @change_eta, @change_batch_size);

% assing callbacks to buttons
hButtonOk = prepare_ok_button(draw_panel);
hButtonOk.Callback = @(~, ~) send_results(getResultsCallback);
hButtonClear = prepare_clear_button(draw_panel);
hButtonClear.Callback = @(~, ~) eraseCallback();
hButtonHelp = prepare_help_button(draw_panel);
hButtonHelp.Callback = @(~, ~) show_help();

    %% AUXILIARY FUNCTIONS
    function change_eta(eta)
        % change learning parameter callback
        network_handle = network_handle.set_eta(eta);
    end

    function change_batch_size(batch_size)
        % change learning parameter callback
        network_handle = network_handle.set_batch_size(batch_size);
    end

    function new_network()
        % create new network callback
        network_handle = network_create_handle();
        hTextResult.String = 'Succesfully created a brand new network for experiments';
        update_plot(0);
    end

    function learn_network()
        % learn network and display results
        epochs = spinner.value;
        bar = waitbar(0, 'Please wait, I am learning...', 'WindowStyle', 'modal');
        for e = 1:epochs
            [network_handle, res, epochs_learned] = network_handle.learn_me_one_epoch(true);
            hTextResult.String = sprintf(['Currently I am able to recognize ', ...
                'correctly %d digits from training set of size %d. ', ...
                'I have learned %d epochs so far.'], res, epochs_learned);
            network_handle = network_handle.set_epochs_scores([network_handle.epochs_scores res(1)]);
            update_plot(epochs_learned);
            waitbar(e/epochs);
            %             waitbar(e/epochs, sprintf('Please wait, I am learning. (%d/%d)', e, epochs));
        end
        close(bar);
    end

    function update_plot(epochs_learned)
        % add another value to learning accuracy visualization
        idxs = floor(linspace(1, epochs_learned+1, min(epochs_learned+1, 10)));
        epoch_plot.XData = 0:length(idxs)-1;
        epoch_plot.YData = network_handle.epochs_scores(idxs);
        epoch_ax.XTick = 0:length(idxs)-1;
        epoch_ax.XTickLabels = idxs - 1;
    end

    function send_results(results_callback)
        % get result and evaluate
        a = results_callback();
%         DEBUG
%         figure;
%         image(a);
        hTextResult.String = sprintf('I think it''s digit %d', ...
            network_handle.evaluate(normalize_matrix(a)));
    end

    function save_game(fname)
        % save network
        bar = waitbar(0, 'Saving...');
        try    
            save(fname, 'network_handle');
            hTextResult.String = 'Network saved succesfully';
        catch exc
            d = warndlg(exc.message);
            set(d, 'WindowStyle', 'modal');
        end
        close(bar);
    end

    function load_game(fname)
        % load previously used network
        % loading bug workaround
        hFig.SelectionType = 'alt';
        if exist(fname, 'file') == 2
            bar = waitbar(0, 'Loading...');
            set(bar, 'WindowStyle', 'modal');
            clear network_handle
            load(fname, 'network_handle');
            update_plot(network_handle.epochs_learned);
            hTextResult.String = 'Network loaded succesfully';
            close(bar);
        else
            warndlg('Selected file does not exist!');
        end
        hFig.SelectionType = 'normal';
    end

    function show_help()
        % shows help dialog for the user
        d = helpdlg(['This program server for creation and training of neural', ...
            ' networks and using them to recognize handwritten digits. Start', ...
            ' by creating a new network with "New" button. Network can be trained', ...
            ' by choosing number of training epochs and pressing the button "Learn"', ...
            '. The progress is shown on the right. Once the network is trained,', ... 
            ' it can be used for a recognition of digits. Use the drawer on the left.', ...
            ' Learned network can be also saved and loaded for further use.']);
        set(d, 'WindowStyle', 'modal');
    end
end

function hText = prepare_results_text(parent_panel)
% PREPARE_RESULTS_TEXT initializes informational component
%   Inputs:
%       parent_panel = panel where the text component resides
%   Outputs:
%       hText = handle of the component
hText = uicontrol('Parent', parent_panel, ...
    'Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0 0 1 0.6], ...
    'FontSize', 12, ...
    'String', 'Nothing drawn yet!');
end

function hButton = prepare_ok_button(parent_panel)
% PREPARE_LEARN_BUTTON prepares button for sending image to evaluation
%   Inputs:
%       parent_panel = panel where the button resides
%   Outputs:
%       hButton = handle of the button
hButton = uicontrol('Parent', parent_panel, ...
    'Style', 'pushbutton', ...
    'TooltipString', 'Send the drawing to evaluation', ...
    'Units', 'normalized', ...
    'String', 'Ok');
e = hButton.Extent;
hButton.Position = [(1/4 - e(3)) 0.1 - e(4) / 2 2*e(3) e(4)];
end

function hButton = prepare_clear_button(parent_panel)
% PREPARE_LEARN_BUTTON prepares button for clearing the drawboard
%   Inputs:
%       parent_panel = panel where the button resides
%   Outputs:
%       hButton = handle of the button
hButton = uicontrol('Parent', parent_panel, ...
    'Style', 'pushbutton', ...
    'TooltipString', 'Clear Picture', ...
    'Units', 'normalized', ...
    'String', 'Clear');
e = hButton.Extent;
hButton.Position = [(2/4 - e(3)) 0.1 - e(4) / 2 2*e(3) e(4)];
end

function hButton = prepare_help_button(parent_panel)
% PREPARE_LEARN_BUTTON prepares button for help
%   Inputs:
%       parent_panel = panel where the button resides
%   Outputs:
%       hButton = handle of the button
hButton = uicontrol('Parent', parent_panel, ...
    'Style', 'pushbutton', ...
    'TooltipString', 'Show help', ...
    'Units', 'normalized', ...
    'String', 'Help');
e = hButton.Extent;
hButton.Position = [(3/4 - e(3)) 0.1 - e(4) / 2 2*e(3) e(4)];
end