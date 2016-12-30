classdef DigitsNeuralNet
    %doc
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
            obj.eta = eta;
        end
        
        function obj = set_batch_size(obj, batch_size)
            obj.batch_size = batch_size;
        end
        
        function obj = set_training_data(obj, training_data)
            obj.training_data = training_data;
        end
        
        function obj = set_test_data(obj, test_data)
            obj.test_data = test_data;
        end
        
        function obj = set_epochs_scores(obj, scores)
            obj.epochs_scores = scores;
        end
        
        function [obj, results, epochs_learned] = learn_me_one_epoch(obj, debug)
            obj = obj.stochastic_gradient_descent();
            obj.epochs_learned = obj.epochs_learned + 1;
            results = obj.test_network();
            if debug
                fprintf('Epoch %d: %d / %d\n', obj.epochs_learned, results);
            end
            epochs_learned = obj.epochs_learned;
        end
        
        function [obj, results, epochs_learned] = learn_me_multiple_epochs(obj, epochs, debug)
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
            for n = 1:obj.num_layers - 1
                a = sigmoidal_function(obj.weights{n}*a + obj.biases{n});
            end
        end
        
        function a = feedbackward(obj, a)
            for n = obj.num_layers - 1:-1:1
                a = sigmoidal_function((obj.weights{n}^-1)*(a - obj.biases{n}));
            end
        end
        
        function result = test_network(obj)
            result = [obj.evaluate_results(), length(obj.test_data)];
        end
        
        function num = evaluate(obj, a)
            a = obj.feedforward(a);
            num = DigitsNeuralNet.find_max_idx(a) - 1;
        end
    end
    
    methods (Static = true)
        function idx = find_max_idx(a)
            [~,idx] = max(a(:));
        end
    end
end