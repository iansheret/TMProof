function x_failing = look_for_failure_nearby(f, x)
%LOOK_FOR_FAILURE_IN_RANGE Do quick non-exhausive search near a point
%   LOOK_FOR_FAILURE_IN_RANGE(f, x0, x1) executes the function f(x) for a
%   range of values near x. If the function returns false for any of these
%   tests, x_failing is set to that x, otherwise x is returned empty.

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

% Make a search grid
x_grid = get_all_doubles_between(x - 5*eps(x), x + 5*eps(x));

% Test each x
for x = x_grid
    if ~f(x)
        x_failing = x;
        return 
    end
end

x_failing = [];

end
