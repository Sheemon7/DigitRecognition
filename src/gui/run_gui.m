function run_gui(network_create_handle)

network_handle = 0;
new_network();
hFig = create_fig();
[draw_panel, load_panel, learn_panel, res_panel] = create_main_panels(hFig);
[~, getResultsCallback, eraseCallback] = draw_digit(28, hFig, draw_panel);
hTextResult = prepare_results_text(res_panel);
prepare_load_panel(load_panel, @new_network, @save_game, @load_game);
[spinner, epoch_plot, epoch_ax] = prepare_learn_panel(learn_panel, @learn_network, ...
    @change_eta, @change_batch_size);

hButtonOk = prepare_ok_button(draw_panel);
hButtonOk.Callback = @(~, ~) send_results(getResultsCallback);
hButtonClear = prepare_clear_button(draw_panel);
hButtonClear.Callback = @(~, ~) eraseCallback();
hButtonHelp = prepare_help_button(draw_panel);
hButtonHelp.Callback = @(~, ~) show_help_helper();

    function change_eta(eta)
        network_handle = network_handle.set_eta(eta);
    end

    function change_batch_size(batch_size)
        network_handle = network_handle.set_batch_size(batch_size);
    end

    function new_network()
        network_handle = network_create_handle();
        update_plot(0);
    end

    function learn_network()
        epochs = spinner.value;
        bar = waitbar(0, 'Please wait, I am learning...');
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
        idxs = floor(linspace(1, epochs_learned+1, min(epochs_learned+1, 10)));
        epoch_plot.XData = 0:length(idxs)-1;
        epoch_plot.YData = network_handle.epochs_scores(idxs);
        epoch_ax.XTick = 0:length(idxs)-1;
        epoch_ax.XTickLabels = idxs - 1;
    end

    function send_results(results_callback)
        a = results_callback();
%         DEBUG
%         figure;
%         image(a);
        hTextResult.String = sprintf('I think it''s digit %d', ...
            network_handle.evaluate(normalize_matrix(a)));
    end

    function show_help_helper()
        %         TODO predeat
        show_help();
    end

    function save_game(fname)
        bar = waitbar(0, 'Saving...');
        save(fname, 'network_handle');
        hTextResult.String = 'Network saved succesfully';
        close(bar);
    end

    function load_game(fname)
        if exist(fname, 'file') == 2
            bar = waitbar(0, 'Loading...');
            clear network_handle
            load(fname, 'network_handle');
            update_plot(network_handle.epochs_learned);
            hTextResult.String = 'Network loaded succesfully';
            close(bar);
        else
            warndlg('Selected file does not exist!');
        end
    end
end

function hText = prepare_results_text(parent_panel)
hText = uicontrol('Parent', parent_panel, ...
    'Style', 'text', ...
    'Units', 'normalized', ...
    'Position', [0 0 1 0.6], ...
    'FontSize', 12, ...
    'String', 'Nothing drawn yet!');
end

function hButton = prepare_ok_button(parent_panel)
hButton = uicontrol('Parent', parent_panel, ...
    'Style', 'pushbutton', ...
    'TooltipString', 'Send the drawing to evaluation', ...
    'Units', 'normalized', ...
    'String', 'Ok');
e = hButton.Extent;
hButton.Position = [(1/4 - e(3)) 0.1 - e(4) / 2 2*e(3) e(4)];
end

function hButton = prepare_clear_button(parent_panel)
hButton = uicontrol('Parent', parent_panel, ...
    'Style', 'pushbutton', ...
    'TooltipString', 'Clear Picture', ...
    'Units', 'normalized', ...
    'String', 'Clear');
e = hButton.Extent;
hButton.Position = [(2/4 - e(3)) 0.1 - e(4) / 2 2*e(3) e(4)];
end

function hButton = prepare_help_button(parent_panel)
hButton = uicontrol('Parent', parent_panel, ...
    'Style', 'pushbutton', ...
    'TooltipString', 'Show help', ...
    'Units', 'normalized', ...
    'String', 'Help');
e = hButton.Extent;
hButton.Position = [(3/4 - e(3)) 0.1 - e(4) / 2 2*e(3) e(4)];
end