function [res, res_handle, erase_handle] = draw_digit(pixels, hFig, parent_panel)

debug = nargin == 1;

muls = [];
sides = [];
matrix = [];
res = zeros(pixels);
click = false;

if debug
    hFig = figure;
    hFig.MenuBar = 'none';
    hFig.Name = 'Digit Recognition';
    hFig.NumberTitle = 'off';
    hFig.ToolBar = 'none';
    parent_panel = hFig;
    p = [0 0 1 1];
else
    hFig.Units = 'pixels';
    p = [0 0.2 1 0.8];
end

hAx = axes('Parent', parent_panel, ...
    'Units', 'normalized', ...
    'Position', p);

menu = uicontextmenu;
uimenu(menu, 'Label', 'Clear', 'Callback', @(~, ~) erase());

im = image(hAx, []);

colormap(gray);

hFig.WindowButtonDownFcn = @(src, event) toggle_click(src, event);
hFig.WindowButtonUpFcn = @(src, event) toggle_click(src, event);
hFig.WindowButtonMotionFcn = @(src, event) aux(src, event);
hFig.SizeChangedFcn = @(~, ~) setup();
res_handle = @get_results;
erase_handle = @erase;

setup();

    function setup()
%         if ~debug
%             sides(:) = hFig.Position(3);
%             sides = floor(sides / 2);
%         else
%             sides = hAx.Position(3:4);
%         end
        hAx.Units = 'pixels';
        sides = floor(hAx.Position(3:4));
        hAx.Units = 'normalized';
        muls = floor(sides / pixels);
        matrix = zeros(sides);
        show_borders();
        im = image(hAx, matrix);
        set(im, 'uicontextmenu', menu);
        set(hAx, 'XTick', [], ...
            'YTick', []);
    end

    function toggle_click(src, event)
        click = ~click;
        aux(src, event);
    end

    function aux(src, ~)
        if click
            hAx.Units = 'pixels';
            tmp = num2cell(hAx.Position);
            hAx.Units = 'normalized';
            [x, y, width, height] = deal(tmp{:});
            point = src.CurrentPoint - [x, y];
            r = pixels - floor((point(2) / sides(2)) * pixels);
            c = floor((point(1) / sides(1)) * pixels) + 1;
            fill_in_result(r, c);
            r = sides(1) - floor(point(2) / height * sides(1));
            c = floor(point(1) / width * sides(2)) + 1;
            fill_in_img(r, c);
            im.CData = matrix;
        end
    end

    function fill_in_result(r, c)
        res(max(r-1, 1):min(r+1, pixels), ...
            max(c-1, 1):min(c+1, pixels)) = 255;
    end

    function fill_in_img(r, c)
        [X, Y] = meshgrid(r-muls(2):r+muls(2), c-muls(1):c+muls(1));
        idxs = (X > 0 & Y > 0 & ...
            (X - r).^2 + (Y - c).^2 <= mean(muls)^2);
        
        %predelat
        for n = find(idxs)'
            matrix(X(n), Y(n)) = 255;
        end
        %             matrix(X(idxs), Y(idxs)) = 255;
    end

    function erase()
        matrix(:) = 0;
        res(:) = 0;
        show_borders();
        im.CData = matrix;
    end

    function mat = get_results()
%         figure;
%         image(res);
        mat = res;
    end

    function show_borders()
        matrix(floor(7/8*sides(1)), :) = 100;
        matrix(floor(1/8*sides(1)), :) = 100;
        matrix(:, floor(7/8*sides(2))) = 100;
        matrix(:, floor(1/8*sides(2))) = 100;
        matrix(floor(sides(1)/2), ...
            floor(sides(2)/2-sides(2)/50):floor(sides(2)/2+sides(2)/50)) = 100;
        matrix(floor(sides(1)/2-sides(1)/50):floor(sides(1)/2+sides(1)/50), ...
            floor(sides(2) / 2)) = 100;
    end

if debug
    uiwait();
end

end

