function hFig = create_fig()
% CREATE_FIG creates figure - main window of application
%   Outputs:
%       hFig = returned figure
hFig = figure();
hFig.MenuBar = 'none';
hFig.Color = 'white';
hFig.Name = 'Digit Recognition';
hFig.NumberTitle = 'off';
% hFig.Resize = 'off';
hFig.ToolBar = 'none';
hFig.Units = 'normalized';
% hFig.OuterPosition = [0 0 1 1];
% hFig.Position = [0 0 1 1];
end

