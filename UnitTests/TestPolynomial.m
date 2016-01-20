function tests = TestPolynomial
%TESTPOLYNOMIAL Unit tests for polynomial functions.

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

tests = functiontests(localfunctions);

end

% Polynomial bounding
function TestBoundPolynomialGiveCorrectAnswer(testCase)
[l,u] = BoundPolynomial([1,-2,0], 0, 3);
verifyEqual(testCase, l, -1);
verifyEqual(testCase, u, 3);
end

% Polynomial splitting
function TestSplitPolynomialGiveCorrectAnswer(testCase)
[high,low] = SplitPolynomial(1:10, 3);
verifyEqual(testCase, low, 7:10);
verifyEqual(testCase, high, [1:6, 0, 0, 0, 0]);
end
