function out = cross_entropy_function_derivative(y, a)
% COST_FUNCTION_DERIVATIVE computes derivative of cost function of the network
%   Inputs:
%       y = correct image
%       a = actual image
%   Outputs:
%       out = value of the cost function derivative
% See also https://en.wikipedia.org/wiki/Cost_function
out = (a - y);
end