function benchmark

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

tic;
f = @(x) x.*(6.6 - 2.9.*x);
x_min = 0;
x_max = 1;
toll  = 1e-4;
g = invert_function(f, x_min, x_max, toll);
t = toc;

fprintf('Elapsed time is %f seconds.\n', t);

end
