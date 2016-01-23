function y = bound_function(f, x, order)
%BOUND_FUNCTION Bound a function using a taylor model

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

x_tm = TaylorModel.identity(x.lower, x.upper, order);
y_tm = f(x_tm);
y    = bound_polynomial(y_tm.P, x - median(x)) + y_tm.I;

if isnan(y.lower) || isnan(y.upper)
    y = Interval(-Inf, Inf);
end

end