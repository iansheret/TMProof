function Y = bound_polynomial(p, X)
%BOUND_POLYNOMIAL Bound a polynomial within an interval

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

% Get roots of the derivitive
d = polyder(p);
r = roots(d);

% Discard complex roots
is_real_root = abs(imag(r))==0;
r = r(is_real_root);

% Discard roots outside the interval
is_in_interval = X.lower<=r & r<=X.upper;
r = r(is_in_interval);

% Get a list of candidate extrema
x = [X.lower; X.upper; r];
y = polyval(p, x);

% Identify the bounds
Y = Interval(min(y), max(y));

end
