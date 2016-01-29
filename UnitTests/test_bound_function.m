function tests = test_bound_function
%TEST_BOUND_FUNCTION Unit tests for bound_function

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

tests = functiontests(localfunctions);

end

function test_bound_function_gives_correct_answer(test_case)
f = @(x) (x + 3).*(x + 5).*(x + 7) + 1.5;
y = bound_function(f, Interval(0, 3), 3);
verifyEqual(test_case, lower(y), f(0));
verifyEqual(test_case, upper(y), f(3));
end

function test_bound_function_converts_NaNs_to_Infs(test_case)
f = @(x) x.*0./0;
y = bound_function(f, Interval(0, 3), 3);
verifyEqual(test_case, lower(y), -Inf);
verifyEqual(test_case, upper(y), Inf);
end
