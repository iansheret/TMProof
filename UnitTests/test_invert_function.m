function tests = test_invert_function
%TEST_INVERT_FUNCTION Unit tests for invert_function

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

tests = functiontests(localfunctions);

end

function test_non_monotonic_function_is_rejected(test_case)
f = @(x) -x.*(x-1);
x_min = 0;
x_max = 1;
toll  = 1e-4;
invert_f = @() invert_function(f, x_min, x_max, toll);
verifyError(...
    test_case, invert_f, 'invert_function:input_not_monotonic');
end

function test_plausable_result_for_valid_input(test_case)
f = @(x) x.*(6.6 - 2.9.*x);

x_min = 0;
x_max = 1;
toll  = 1e-4;
g = invert_function(f, x_min, x_max, toll);
num_test_points = 1e3;
x_true = linspace(x_min, x_max, num_test_points);
y = f(x_true);
x = zeros(1, num_test_points);
for i=1:num_test_points
    x(i) = g(y(i));
end

verifyEqual(test_case, x, x_true, 'AbsTol', toll);

end
