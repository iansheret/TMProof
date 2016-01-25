function x_failing = look_for_failure_in_range(f, x0, x1)
%LOOK_FOR_FAILURE_IN_RANGE Do quick non-exhausive search over an interval
%   LOOK_FOR_FAILURE_IN_RANGE(f, x0, x1) executes the function f(x) for a
%   range of x between x0 and x1. If f(x) returns false for any of these
%   tests, x_failing is set to that x, otherwise x is returned empty.

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

% Make a search grid
num_points = 1e3;
x_grid = linspace(x0, x1, num_points);

% Add 0 if this is in the search range, as it's a common corner case.
if x0<0 && x1>0
    x_grid(end+1) = 0;
end

% Test each x
for x = x_grid
    if ~f(x)
        x_failing = x;
        return 
    end
end

x_failing = [];

end
