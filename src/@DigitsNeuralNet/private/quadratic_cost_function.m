function out = quadratic_cost_function(y, a)
% COST_FUNCTION computes cost function of the network
%   Inputs:
%       y = correct image
%       a = actual image
%   Outputs:
%       out = value of the cost function
% See also https://en.wikipedia.org/wiki/Cost_function
out = abs(y - a) ./ 2;
end