function obj = update_batch(obj, batch)
% UPDATE_BATCH Updates partial cost function derivatives on given batch
% Inputs:
%   batch = batch of the training data
% See also https://en.wikipedia.org/wiki/Stochastic_gradient_descent
nabla_biases = cell(obj.num_layers - 1, 1);
nabla_weights = cell(obj.num_layers - 1, 1);
for n = 1:obj.num_layers - 1
    nabla_biases{n} = zeros(size(obj.biases{n}));
    nabla_weights{n} = zeros(size(obj.weights{n}));
end

% for each input update deltas
for m=1:obj.batch_size
    [delta_nabla_biases, delta_nabla_weights] = obj.backpropagation(batch{m, 1}, batch{m, 2});
    for n = 1:obj.num_layers - 1
        nabla_biases{n} = nabla_biases{n} + delta_nabla_biases{n};
        nabla_weights{n} = nabla_weights{n} + delta_nabla_weights{n};
    end
end

for n = 1:obj.num_layers - 1
    obj.biases{n} = obj.biases{n} - (obj.eta / obj.batch_size) * nabla_biases{n};
    %% WITHOUT REGULARIZATION
    obj.weights{n} = obj.weights{n} - (obj.eta / obj.batch_size) * nabla_weights{n};
    %% WITH REGULARIZATION
    N = length(obj.training_data);
    obj.weights{n} = (1 - obj.lambda * obj.eta / N) .* obj.weights{n} - (obj.eta / obj.batch_size) * nabla_weights{n};
end
end