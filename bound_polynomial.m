function y = bound_polynomial(p, x)
%BOUND_POLYNOMIAL Bound a polynomial within an interval

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

% Check for non-finite inputs
if any(~isfinite(p))
    y = Interval(-Inf, Inf);
    return
end
    
% Bound using the mean value theorm
x0 = 0.5*(lower(x) + upper(x));
d = polyder(p);
y = eval_polynomial(p,x0) + eval_polynomial(d,x).*(x - x0);

end
