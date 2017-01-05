function [training_data, test_data] = load_mnist()
% LOAD_MNIST loads mnist dataset
%   Inputs:
%   Outputs:
%       training_data = training_data for training
%       test_data = test_data for accuracy evaluation

images = load_mnist_imgs('data\train-images.idx3-ubyte');
labels = load_mnist_labels('data\train-labels.idx1-ubyte');

training_data = cell(length(labels), 2);
for n = 1:length(labels)
    res = result_vector(labels(n));
    training_data{n, 1} = images(:, n);
    training_data{n, 2} = res;
end

images = load_mnist_imgs('data\t10k-images.idx3-ubyte');
labels = load_mnist_labels('data\t10k-labels.idx1-ubyte');

test_data = cell(length(labels), 2);
for n = 1:length(labels)
    test_data{n, 1} = images(:, n);
    test_data{n, 2} = labels(n);
end
end

function vec = result_vector(num)
vec = zeros(10, 1);
vec(num + 1) = 1.0;
end