function [high, low] = split_polynomial(p, n)
%SPLIT_POLYNOMAIL Split a polynomial into high order and low order

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

low = p(end-n : end);
high = [p(1 : end-n-1), zeros(1, n+1)];

end
