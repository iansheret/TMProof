function tests = test_look_for_failure_in_range

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

tests = functiontests(localfunctions);

end

function test_passes_when_input_true(test_case)
f = @(x) 1 - x;
y = Interval(0, 1);
g = @(x) includes(y, f(x));
x_min = 0;
x_max = 1;
x = look_for_failure_in_range(g, x_min, x_max);
verifyEqual(test_case, isempty(x), true);
end

function test_passes_when_input_false(test_case)
f = @(x) 1 - 2.*x;
y = Interval(0, 1);
g = @(x) includes(y, f(x));
x_min = 0;
x_max = 1;
x = look_for_failure_in_range(g, x_min, x_max);
verifyEqual(test_case, 0.5<=x && x<=1, true);
end
