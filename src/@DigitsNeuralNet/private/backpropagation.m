function [nabla_biases, nabla_weights] = backpropagation(obj, x, y)
% BACKPROPAGATION a key algorithm for learning of the network
%   Inputs:
%       x = input vector
%       y = correct image of x after feedforward
%   Outputs:
%       obj = network object
% See also https://en.wikipedia.org/wiki/Backpropagation

nabla_biases = cell(obj.num_layers - 1, 1);
nabla_weights = cell(obj.num_layers - 1, 1);
for n = 1:obj.num_layers - 1
    nabla_biases{n} = zeros(size(obj.biases{n}));
    nabla_weights{n} = zeros(size(obj.weights{n}));
end

a = x;
as = cell(obj.num_layers, 1);
zs = cell(obj.num_layers - 1, 1);
as{1} = x;

for n = 1:obj.num_layers - 1
    z = obj.weights{n}*a + obj.biases{n};    
    zs{n} = z;
    a = sigmoidal_function(z);
    as{n+1} = a;
end

delta = cost_function_derivative(y, as{end}) .* ...
        sigmoidal_function_derivative(zs{end});
nabla_biases{end} = delta;
nabla_weights{end} = delta .* as{end - 1}.';

for n = obj.num_layers-2:-1:1
    delta = (obj.weights{n+1}.' * delta) .* ...
        sigmoidal_function_derivative(zs{n});
    nabla_biases{n} = delta;
    nabla_weights{n} = delta .* as{n}.';
end