function out = sigmoidal_function(z)
% SIGMOIDAL_FUNCTION Takes weighted input z and returns sigmoidal transformation
% Inputs:
%   z = weighted input of the neuron
% Outputs:
%   out = value of transformation
out = 1.0 ./ (1.0 + exp(-z));
end