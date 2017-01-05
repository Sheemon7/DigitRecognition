function [spinner, epoch_plot, epoch_ax] = prepare_learn_panel(learn_panel, learn_network_callback, change_eta_callback, change_batch_size_callback)
% PREPARE_LEARN_PANEL initializes panel for learning
%   Inputs:
%       learn_panel = handle of panel
%       learn_network_callback = callback for initialization of network
%       learning
%       change_eta_callback = callback for changing eta parameter of
%       learning
%       change_batch_size_callback = callback for changing batch_size
%       parameter of learning
%   Outputs:
%       spinner = handle of spinner for number of epochs
%       epoch_plot = handle of plot for visualization of learning
%       epoch_ax = handle of axes of epoch_plot
learn_button = prepare_learn_button(learn_panel);
learn_button.Callback = @(~, ~) learn_network_callback();
spinner = prepare_epochs_spinner(learn_panel);
[epoch_plot, epoch_ax] = prepare_epoch_plot(learn_panel);
% FUTURE VERSIONS not used now
% prepare_eta_slider(learn_panel, change_eta_callback);
% prepare_batch_size_slider(learn_panel, change_batch_size_callback);
end

function prepare_eta_slider(parent_panel, change_eta_callback)
% PREPARE_ETA_SLIDE initializes slider for changing eta learning parameter
%     Inputs:
%         parent_panel = parent of the component
%         change_eta_callback = callback for changing the parameter
slider = uicontrol('Parent', parent_panel, ...
    'Style', 'slider', ...
    'Units', 'normalized', ...
    'Position', [0.2 0.6 0.5 0.1]);
maxVal= 10.0;
minVal= 0;
slider_step(1) = 0.04/(maxVal-minVal);
slider_step(2) = 0.1/(maxVal-minVal);
set(slider, 'SliderStep', ...
    slider_step, 'Max', maxVal, ...
    'Min', minVal, 'Value', 3);
end

function prepare_batch_size_slider(parent_panel, change_batch_size_callback)
% PREPARE_ETA_SLIDE initializes slider for changing batch_size learning parameter
%     Inputs:
%         parent_panel = parent of the component
%         change_batch_size_callback = callback for changing the parameter
slider = uicontrol('Parent', parent_panel, ...
    'Style', 'slider', ...
    'Units', 'normalized', ...
    'Position', [0.2 0.5 0.5 0.1]);
maxVal= 100;
minVal= 0;
slider_step(1) = 0.04/(maxVal-minVal);
slider_step(2) = 0.1/(maxVal-minVal);
set(slider, 'SliderStep', ...
    slider_step, 'Max', maxVal, ...
    'Min', minVal, 'Value',20);
end

function [epoch_plot, hAx] = prepare_epoch_plot(parent_panel)
% PREPARE_EPOCH_PLOT creates plot for visualizing learning results.
%   Inputs:
%         parent_panel = parent of the component
%   Outputs:
%         epoch_plot = handle of the plot
%         hAx = handle of axes
hAx = axes('Parent', parent_panel, 'Units', 'normalized', 'Position', [0.6 0.1 0.35 0.8]);
epoch_plot = plot(hAx, 0, 0);
epoch_plot.Marker = 'o';
epoch_plot.Color = 'b';
title(hAx, 'Learning visualization');
xlabel(hAx, 'epoch');
ylabel(hAx, 'correct', 'FontSize',12,'FontWeight','bold','Color','b');
hAx.XTick = 0;
% hAx.YScale = 'log';
xlim(hAx, [0, inf]);
ylim(hAx, [0, 10000]);
% close all guards
hAx.HandleVisibility = 'off';
epoch_plot.HandleVisibility = 'off';
end

function hSpinner = prepare_epochs_spinner(parent_panel)
% PREPARE_EPOCHS_SPINNER creates spinner capable of changing number of
% learning epochs and returns its handle
%   Inputs:
%       parent_panel = parent of the component
%   Outputs:
%       hSpinner = handle of the newly created spinner
model = javax.swing.SpinnerNumberModel(1, 1, 100, 1);
hSpinner = addLabeledSpinner('&Epochs', model);
jEditor = javaObject('javax.swing.JSpinner$NumberEditor', hSpinner, '#');
hSpinner.setEditor(jEditor);
value = 1;

    function jhSpinner = addLabeledSpinner(label, model)
        % aux function for creation
        posSpinner = [0.25 2/3 0.2 0.1];
        posLabel = [0.05 2/3 0.2 0.1];
        jSpinner = com.mathworks.mwswing.MJSpinner(model);
        [jhSpinner, mtb_handle] = javacomponent(jSpinner, posSpinner, parent_panel);
        mtb_handle.Units = 'normalized';
        mtb_handle.Position = posSpinner;
        set(jhSpinner,'StateChangedCallback', @value_changed);
        jLabel = com.mathworks.mwswing.MJLabel(label);
        jLabel.setLabelFor(jhSpinner);
        [~, mtb_handle] = javacomponent(jLabel, posLabel, parent_panel);
        mtb_handle.Units = 'normalized';
        mtb_handle.Position = posLabel;
    end

    function value_changed(jSpinner, ~) 
        % change the value callback
        new_value = jSpinner.value;
        if new_value > value && jSpinner.value > 10
            d = warndlg('Learning takes pretty much time, have a book prepared to kill some time');
            set(d, 'WindowStyle', 'modal');
        end
        value = new_value; 
    end
end

function hButton = prepare_learn_button(parent_panel)
% PREPARE_LEARN_BUTTON prepares button for learning
%   Inputs:
%       parent_panel = panel where the button resides
%   Outputs:
%       hButton = handle of the button
hButton = uicontrol('Parent', parent_panel, ...
    'Style', 'pushbutton', ...
    'TooltipString', 'Learn the network', ...
    'Units', 'normalized', ...
    'String', 'Learn!');
e = hButton.Extent;
hButton.Position = [(0.25 - e(3)) 1/3 - e(4) / 2 2*e(3) e(4)];
end