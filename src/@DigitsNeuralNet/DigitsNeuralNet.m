classdef DigitsNeuralNet
    % This class represents neural network capable of learning
    properties (SetAccess = 'private') %GetAccess = public
        num_layers = 0;
        sizes = [];
        biases = {};
        weights = {};
        
        % learning params
        batch_size = 10;
        eta = 3.0;
        
        epochs_learned = 0;
        epochs_scores = 0;
        training_data = {};
        test_data = {};
    end
    
    methods
        function obj = DigitsNeuralNet(sizes)
            % DIGITS_NEURAL_NET creates new network with given size of
            % layers
            %   Inputs:
            %       sizes = list of sizes of layers
            %   Outputs:
            %       obj = network object
            obj.sizes = sizes;
            obj.num_layers = length(sizes);
            
            obj.biases = cell(obj.num_layers - 1, 1);
            obj.weights = cell(obj.num_layers - 1, 1);
            
            for n = 1:obj.num_layers - 1
                obj.biases{n} = randn(obj.sizes(n + 1), 1);
                obj.weights{n} = randn(obj.sizes(n + 1), obj.sizes(n));
            end
        end
        
        function obj = set_eta(obj, eta)
            % SET_ETA sets eta learning parameter
            %   Inputs:
            %       eta = new eta parameter
            %   Outputs:
            %       obj = network object
            obj.eta = eta;
        end
        
        function obj = set_batch_size(obj, batch_size)
            % SET_BATCH_SIZE sets batch_size learning parameter
            %   Inputs:
            %       batch_size = new batch_size parameter
            %   Outputs:
            %       obj = network object
            obj.batch_size = batch_size;
        end
        
        function obj = set_training_data(obj, training_data)
            % SET_TRAINING_DATA sets training data to network
            %   Inputs:
            %       training_data = data - cell n * 2, where first column
            %       are images and second results
            %   Outputs:
            %       obj = network object
            obj.training_data = training_data;
        end
        
        function obj = set_test_data(obj, test_data)
            % SET_TEST_DATA sets test data to network
            %   Inputs:
            %       test_data = data - cell n * 2, where first column
            %       are images and second results
            %   Outputs:
            %       obj = network object
            obj.test_data = test_data;
        end
        
        function obj = set_epochs_scores(obj, scores)
            % SET_EPOCHS_SCORES saves scores from previous learning to
            % network
            %   Inputs:
            %       scores = list of previous scores
            %   Outputs:
            %       obj = network object
            obj.epochs_scores = scores;
        end
        
        function [obj, results, epochs_learned] = learn_me_one_epoch(obj, debug)
            % LEARN_ME_ONE_EPOCH learns network one epoch
            %   Inputs:
            %       debug = flag if prints are wanted
            %   Outputs:
            %       obj = network object
            %       results = array of results - [ correct / all]
            %       epochs_learned = number of epochs learned so far             
            obj = obj.stochastic_gradient_descent();
            obj.epochs_learned = obj.epochs_learned + 1;
            results = obj.test_network();
            if debug
                fprintf('Epoch %d: %d / %d\n', obj.epochs_learned, results);
            end
            epochs_learned = obj.epochs_learned;
        end
        
        function [obj, results, epochs_learned] = learn_me_multiple_epochs(obj, epochs, debug)
            % LEARN_ME_MULTIPLE_EPOCHS learns network more epochs
            %   Inputs:
            %       epochs = number of epochs to spend learning             
            %       debug = flag if prints are wanted
            %   Outputs:
            %       obj = network object
            %       results = array of results - [ correct / all]
            %       epochs_learned = number of epochs learned so far 
            for e = 1:epochs
                obj = obj.stochastic_gradient_descent();
                obj.epochs_learned = obj.epochs_learned + 1;                
                            
            end
            results = obj.test_network();
            if debug
                    fprintf('Epoch %d: %d / %d\n', obj.epochs_learned, results);
            end    
            epochs_learned = obj.epochs_learned;
        end
        
        function a = feedforward(obj, a)
            % FEEDFORWARD feedforwards input a through network
            %   Inputs:
            %       a = image (pixels of it)
            %   Outputs:
            %       a = resulting vector from the network
            for n = 1:obj.num_layers - 1
                a = sigmoidal_function(obj.weights{n}*a + obj.biases{n});
            end
        end
        
        function result = test_network(obj)
            % TEST_NETWORK tests accuracy of the network and returns the
            % results
            %   Outputs:
            %       result = arrray [ correct, all]
            result = [obj.evaluate_results(), length(obj.test_data)];
        end
        
        function num = evaluate(obj, a)
            % EVALUATE feedforwards input a through network and returns
            % guessed numbers
            %   Outputs:
            %       num = guessed number
            a = obj.feedforward(a);
            num = DigitsNeuralNet.find_max_idx(a) - 1;
        end
    end
    
    methods (Static = true)
        function idx = find_max_idx(a)
            % FIND_MAX_IDX finds index where the maximal element of array
            % resides
            % Inputs:
            %   a = input array
            % Outputs:
            %   idx = index of the maximal element             
            [~,idx] = max(a(:));
        end
    end
end