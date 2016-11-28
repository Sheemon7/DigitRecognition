import numpy as np

class Network:

    def __init__(self, sizes):
        self.num_layers = len(sizes)
        self.sizes = sizes
        # not for first/input layer
        self.biases = [np.random.randn(y, 1) for y in sizes[1:]]
        self.weights = [np.random.rand(y, x) for x, y in zip(sizes[:-1], sizes[1:])]


def sigmoid(z):
    return 1.0 / (1.0 + np.exp(-z))

if __name__ == "__main__":
    # example of usage
    net = Network([2, 3, 1]) # network with two inputs, one hidden layer and one output