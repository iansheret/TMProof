function y = eval_polynomial(p, x)
%EVAL_POLYNOMIAL Evaluate polynomial
%   This function replicates the built-in function polyval, but extends
%   support to include non-numeric types which have addition and
%   multiplication opperators.

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

% Evaluate using the Horner scheme
y = p(1);
for i=2:length(p)
    y = y.*x + p(i);
end

end
