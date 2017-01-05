function labels = load_mnist_labels(filename)
% LOAD_MNIST_LABELS loads mnist labels
%   Inputs:
%       filename = name of the file
%   Outputs:
%       labels = labels of the images
%   copyright : http://ufldl.stanford.edu/wiki/index.php/Using_the_MNIST_Dataset

fp = fopen(filename, 'rb');
assert(fp ~= -1, ['Could not open ', filename, '']);

magic = fread(fp, 1, 'int32', 0, 'ieee-be');
assert(magic == 2049, ['Bad magic number in ', filename, '']);

numLabels = fread(fp, 1, 'int32', 0, 'ieee-be');

labels = fread(fp, inf, 'unsigned char');

assert(size(labels,1) == numLabels, 'Mismatch in label count');

fclose(fp);

end
