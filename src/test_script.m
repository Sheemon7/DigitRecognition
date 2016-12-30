addpath .\data .\gui
close all;
a = draw_digit(28);
image(a);
network.evaluate(normalize_matrix(a))
rmpath .\data .\gui