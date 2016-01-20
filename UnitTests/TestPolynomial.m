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
