function out = sigmoidal_function_derivative(z)
out = sigmoidal_function(z) .* (1 - sigmoidal_function(z));
end