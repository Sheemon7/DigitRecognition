function obj = stochastic_gradient_descent(obj)
n = length(obj.training_data);
idxs = randperm(n);
k = 1;
while k < n
    obj = obj.update_batch(obj.training_data(idxs(k:k+obj.batch_size-1), :));
    k = k + obj.batch_size;
end
obj = obj.update_batch(obj.training_data(idxs(k-n:n), :));
end