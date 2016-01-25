function g = invert_function(f, x_min, x_max, toll)
%INVERT_FUNCTION Invert a function between specified bounds.
%   G = invert_funcion(F, X_MIN, X_MAX, TOLL) takes a function handle F and
%   returns its inverse function G. That is, if F defines a function
%   y = f(x), then G will define x = g(y).
%
%   The supplied function must be monotonic between the limits X_MIN and
%   X_MAX. The output function is only gaurenteed to be valid between
%   F(X_MIN) and F(X_MAX).
%
%   The worst-case accuracy of G is specified by the parameter TOLL.

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

% Define search parameters
order = 10;
max_newton_order = 5;

% Check that the function is monotonic
df_dx = @(x) get_gradient(f, x);
if f(x_max) > f(x_min)
    is_monotonic = prove_in_band(df_dx, x_min, x_max, 0, Inf, order);
else
    is_monotonic = prove_in_band(df_dx, x_min, x_max, -Inf, 0, order);
end
if ~is_monotonic
    error('invert_function:input_not_monotonic','Input is not monotonic.');
end

% Search for an inversion strategy which can be proved to meet the accuracy
% requirement
for n=1:max_newton_order
    g = @(y) invert_with_fixed_iter(f, y, x_min, x_max, n);
    residual = @(x) x - g(f(x));
    is_ok = prove_in_band(residual, x_min, x_max, -toll, toll, order);
    if is_ok
        break
    end
end

if ~is_ok
    error(...
        'invert_function:could_not_find_inversion',...
        'Failed to invert function');
end

end

function df_dx = get_gradient(f, x)
    y     = f(Autodiff(x));
    df_dx = y.d;
end

function x = invert_with_fixed_iter(f, y, x_min, x_max, n)

% Get initialisation
y0 = f(x_min);
y1 = f(x_max);
x = x_min + (y-y0).*(x_max-x_min)./(y1-y0);

% Improve with Newton-Raphson
for i = 1:n
    fx = f(Autodiff(x, 1));
    x = x - (fx.x-y)./fx.d;
end

end
