function [training_data, test_data] = load_data(folder)
% LOAD_DATA loads mnist dataset from give folder
%   Inputs:
%       folder = folder, where dataset file resists
%   Outputs:
%       training_data = training_data for training
%       test_data = test_data for accuracy evaluation

data = {};
for number = 0:9
    fpath = fullfile(folder, sprintf('data%d.txt', number));
    fid=fopen(fpath,'r');
    res = result_vector(number);
    while ~feof(fid)
        [img, ~]=fread(fid,[28 28],'uchar');
        if isempty(img)
            break;
        end
        img = normalize_matrix(img');
        data = [data; {img, res}];
    end
    fclose(fid);
end

data = data(randperm(length(data)), :);
half = 9000;
training_data = data(1:half, :);
test_data = data(half+1:end, :);
end

function vec = result_vector(num)
vec = zeros(10, 1);
vec(num + 1) = 1.0;
end
