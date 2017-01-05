function main()
% MAIN initializes whole program

clear; clc; close all;
addpath ..\data gui
[training_data, test_data] = load_mnist();
batch_size = 20;
eta = 3.0;
run_gui(@create_new_network);

    function network = create_new_network()
        % CREATE_NEW_NETWORK creats new neural network from scratch
        %   Inputs:
        %   Outputs:
        %       network object capable of learning
        network = DigitsNeuralNet([784, 50, 10]);
        network = network.set_eta(eta);
        network = network.set_batch_size(batch_size);
        network = network.set_training_data(training_data);
        network = network.set_test_data(test_data);
    end

rmpath ..\data gui

end