function out = sigmoidal_function_derivative(z)
% SIGMOIDAL_FUNCTION_DERIVATIVE Takes weighted input z and returns sigmoidal derivative transformation
% Inputs:
%   z = weighted input of the neuron
% Outputs:
%   out = value of transformation
out = sigmoidal_function(z) .* (1 - sigmoidal_function(z));
end