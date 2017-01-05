function matrix = normalize_matrix(matrix)
% NORMALIZE_MATRIX transforms matrix of pixels to format readable by
% network
%   Inputs:
%       matrix = matrix of pixels
%   Outputs:
%       matrix = matrix in format readable by network
matrix = (matrix > 0);
matrix = matrix(:);
end

