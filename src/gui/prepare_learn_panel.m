function [spinner, epoch_plot, epoch_ax] = prepare_learn_panel(learn_panel, learn_network_callback, change_eta_callback, change_batch_size_callback)

learn_button = prepare_learn_button(learn_panel);
learn_button.Callback = @(~, ~) learn_network_callback();
spinner = prepare_epochs_spinner(learn_panel);
[epoch_plot, epoch_ax] = prepare_epoch_plot(learn_panel);
% FUTURE VERSIONS
% prepare_eta_slider(learn_panel, change_eta_callback);
% prepare_batch_size_slider(learn_panel, change_batch_size_callback);
end

function prepare_eta_slider(parent_panel, change_eta_callback)
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
hAx = axes('Parent', parent_panel, 'Units', 'normalized', 'Position', [0.6 0.1 0.35 0.8]);
epoch_plot = plot(hAx, 0, 0);
epoch_plot.Marker = 'o';
epoch_plot.Color = 'c';
title(hAx, 'Learning visualization');
xlabel(hAx, 'epoch');
ylabel(hAx, 'correct', 'FontSize',12,'FontWeight','bold','Color','r');
hAx.XTick = 0;
% hAx.YScale = 'log';
xlim(hAx, [0, inf]);
ylim(hAx, [0, 10000]);
end

function hSpinner = prepare_epochs_spinner(parent_panel)
model = javax.swing.SpinnerNumberModel(1, 1, 100, 1);
hSpinner = addLabeledSpinner('&Epochs', model);
jEditor = javaObject('javax.swing.JSpinner$NumberEditor', hSpinner, '#');
hSpinner.setEditor(jEditor);

    function jhSpinner = addLabeledSpinner(label, model)
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
        if jSpinner.value > 10
            disp('TODO')
        end
    end
end

function hButton = prepare_learn_button(parent_panel)
hButton = uicontrol('Parent', parent_panel, ...
    'Style', 'pushbutton', ...
    'TooltipString', 'Learn the network', ...
    'Units', 'normalized', ...
    'String', 'Learn!');
e = hButton.Extent;
hButton.Position = [(0.25 - e(3)) 1/3 - e(4) / 2 2*e(3) e(4)];
end