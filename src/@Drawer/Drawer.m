classdef Drawer
    
    properties (SetAccess = 'private')
        mul = 4;
        side = pixels * mul;
        matrix = zeros(side);
        res = zeros(pixels);
        click = false;
    end
    
    methods
        function obj = Drawer(pixels, parent_fig)
            
        end
    end
    
end

