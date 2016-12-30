function out = sigmoidal_function(z)
% Takes weighted input z and returns sigmoidal transformation
out = 1.0 ./ (1.0 + exp(-z));
end