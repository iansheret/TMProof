function tests = test_TaylorModel
%TEST_TAYLORMODEL Unit tests for the Interval class.

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

tests = functiontests(localfunctions);

end

% Constructor
function test_constructor_generates_valid_object(test_case)
t = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
verifyEqual(test_case, t.a, 1);
verifyEqual(test_case, t.b, 2);
verifyEqual(test_case, t.P, [3,4,5]);
verifyEqual(test_case, t.I.lower, 6);
verifyEqual(test_case, t.I.upper, 7);
end

% Named constructor for the identity function
function test_identity_constructor_generates_correct_object(test_case)
t = TaylorModel.identity(1, 2, 5);
verifyEqual(test_case, t.a, 1);
verifyEqual(test_case, t.b, 2);
verifyEqual(test_case, t.P, [0, 0, 0, 0, 1, 1.5]);
verifyEqual(test_case, t.I.lower, 0);
verifyEqual(test_case, t.I.upper, 0);
end

% Fundamental opperators
% Plus
function test_plus_tm_tm_gives_correct_answer(test_case)
a = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
b = TaylorModel(1, 2, [8,9,10], Interval(11, 12));
t = plus_tm_tm(a,b);
verifyEqual(test_case, t.a, 1);
verifyEqual(test_case, t.b, 2);
verifyEqual(test_case, t.P, [11,13,15]);
verifyEqual(test_case, t.I.lower, 17);
verifyEqual(test_case, t.I.upper, 19);
end

function test_plus_tm_numeric_gives_correct_answer(test_case)
a = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
b = 8;
t = plus_tm_numeric(a,b);
verifyEqual(test_case, t.a, 1);
verifyEqual(test_case, t.b, 2);
verifyEqual(test_case, t.P, [3,4,13]);
verifyEqual(test_case, t.I.lower, 6);
verifyEqual(test_case, t.I.upper, 7);
end

function test_plus_gives_correct_answer(test_case)
a = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
b = TaylorModel(1, 2, [8,9,10], Interval(11, 12));
c = 8;
verifyEqual(test_case, a+b, plus_tm_tm(a,b));
verifyEqual(test_case, a+c, plus_tm_numeric(a,c));
verifyEqual(test_case, c+a, plus_tm_numeric(a,c));
end

%Times
function test_times_tm_tm_gives_correct_answer_for_identity(test_case)
a = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
b = TaylorModel(1, 2, [0,0,1], Interval(0, 0));
t = times_tm_tm(a,b);
verifyEqual(test_case, t.a, 1);
verifyEqual(test_case, t.b, 2);
verifyEqual(test_case, t.P, [3,4,5]);
verifyEqual(test_case, t.I.lower, 6);
verifyEqual(test_case, t.I.upper, 7);
end

function test_times_tm_tm_without_truncation(test_case)
% Consider the following two functions
%
% a = 3x + 4 + [-2, 1]
% b = 5x + 6 + [-1, 3]
%
% The taylor expansion around x0=1.5 is
%
% a = 3(x-x0) + 8.5  + [-2, 1]
% b = 5(x-x0) + 13.5 + [-1, 3]
%
% Expected answer for the polynomial part is 
%
% t = 15(x-x0)^2 + 83(x-x0) + 114.75
%
% The bounds on the two polynomials in the range x = [1, 2] are
%
% B(a) = [7,10]
% B(b) = [11,16]
%
% The interval is then given by
%
% I = [7,10]*[-1,3] + [11,16]*[-2,1] + [-2,1]*[-1,3]
%   = [-10,30]      + [-32,16]       + [-6,3]
%   = [-48,49]

a = TaylorModel(1, 2, [0,3,8.5], Interval(-2, 1));
b = TaylorModel(1, 2, [0,5,13.5], Interval(-1, 3));
t = times_tm_tm(a,b);
verifyEqual(test_case, t.a, 1);
verifyEqual(test_case, t.b, 2);
verifyEqual(test_case, t.P, [15,83,114.75]);
verifyEqual(test_case, t.I.lower, -48);
verifyEqual(test_case, t.I.upper, 49);
end

function test_times_tm_tm_with_truncation(test_case)
% With truncation, the polynomial part becomes
%
% t = 83(x-x0) + 114.75
%
% and the interval part gains an extra term from the high order polynomial.
% The high order part is 
%
% h = 15(x-x0)^2
%
% and its bounds in the range (x-x0) = [-0.5,0.5] are
%
% B(h) = [0, 3.75];
%
% The interval is then
%
% I = [0, 3.75] + [7,10]*[-1,3] + [11,16]*[-2,1] + [-2,1]*[-1,3]
%   = [0, 3.75] + [-10,30]      + [-32,16]       + [-6,3]
%   = [-48,52.75]

a = TaylorModel(1, 2, [3,8.5], Interval(-2, 1));
b = TaylorModel(1, 2, [5,13.5], Interval(-1, 3));
t = times_tm_tm(a,b);
verifyEqual(test_case, t.a, 1);
verifyEqual(test_case, t.b, 2);
verifyEqual(test_case, t.P, [83,114.75]);
verifyEqual(test_case, t.I.lower, -48);
verifyEqual(test_case, t.I.upper, 52.75);
end

function test_times_tm_numeric(test_case)
a = TaylorModel(1, 2, [3,8.5], Interval(-2, 1));
b = 7;
t = times_tm_numeric(a,b);
verifyEqual(test_case, t.a, 1);
verifyEqual(test_case, t.b, 2);
verifyEqual(test_case, t.P, [21,59.5]);
verifyEqual(test_case, t.I.lower, -14);
verifyEqual(test_case, t.I.upper, 7);
end

function test_times_gives_correct_answer(test_case)
a = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
b = TaylorModel(1, 2, [8,9,10], Interval(11, 12));
c = 8;
verifyEqual(test_case, a.*b, times_tm_tm(a,b));
verifyEqual(test_case, a.*c, times_tm_numeric(a,c));
verifyEqual(test_case, c.*a, times_tm_numeric(a,c));
end

% Unary minus
function test_uminus_gives_correct_answer(test_case)
a = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
t = -a;
verifyEqual(test_case, t.a, 1);
verifyEqual(test_case, t.b, 2);
verifyEqual(test_case, t.P, [-3,-4,-5]);
verifyEqual(test_case, t.I.lower, -7);
verifyEqual(test_case, t.I.upper, -6);
end

% Minus
function test_minus_gives_correct_answer(test_case)
a = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
b = TaylorModel(1, 2, [8,9,10], Interval(11, 12));
t = a-b;
verifyEqual(test_case, t.a, 1);
verifyEqual(test_case, t.b, 2);
verifyEqual(test_case, t.P, [-5,-5,-5]);
verifyEqual(test_case, t.I.lower, -6);
verifyEqual(test_case, t.I.upper, -4);
end

% Includes zero
function test_includes_zero_when_true(test_case)
% f = x + 4 + [-5, 5]
%   = (x-x0) + x0 + 4 + [-5, 5]
%   = (x-x0) + 5.5 + [-5, 5]
a = TaylorModel(1, 2, [1,5.5], Interval(-5, 5));
verifyEqual(test_case, includes_zero(a), true);
end

function test_includes_zero_when_false(test_case)
a = TaylorModel(1, 2, [1,5.5], Interval(-4.999, 5));
verifyEqual(test_case, includes_zero(a), false);
end

% Reciprocal
function test_reciprocal_when_input_includes_zero(test_case)
a = TaylorModel(1, 2, [1,5.5], Interval(-5, 5));
t = reciprocal(a);
verifyEqual(test_case, t.a, 1);
verifyEqual(test_case, t.b, 2);
verifyEqual(test_case, t.P, [0,0]);
verifyEqual(test_case, t.I.lower, -Inf);
verifyEqual(test_case, t.I.upper, Inf);
end

function test_reciprocal_when_input_excludes_zero(test_case)
% f = 2x + 3 + [-1, 2]
%
% Take the interval [0.5,1.5], so x0 = 1. Then the taylor model is
%
% t = 2(x - x0) + 2*x0 + 3 + [-1, 2]
%     2(x - x0) + 5 + [-1, 2]
% 
% Constant part of this is c=5. Non-constant part is 
%
% f_bar = 2(x - x0) + [-1, 2]
%
% hence
%
% f_bar^2 = 4(x - x0)^2 + [-6, 8]
%
% The reciprocal is given by
%
% 1/t = (1/c)*(1 - f_bar/c) + f_bar^2/((c^2)*(1 + theta*f_bar/c)^3)
%       \-polynomial part-/   \-----------remainder part----------/
%
% with theta = [0, 1]. Evaluating the polynomial part gives
% 
% pp = -0.08*(x-x0) + 0.2 + [-0.08, 0.04]
%
% For the remainder part, first bound f_bar
%
% B(f_bar)   = [-2, 3]
%
% Then the remainder part can be evaluated with interval arithmatic:
%
% rp = [-2, 3]^2 / (125*(1 + [0,1]*[-2,3]/5)^3)
%    = [0, 1/3]
%
% The final taylor model is then
%
% -0.08*(x-x0) + 0.2 + [-0.08, 28/75]
%
a = TaylorModel(0.5, 1.5, [2,5], Interval(-1,2));
t = reciprocal(a);
verifyEqual(test_case, t.a, 0.5);
verifyEqual(test_case, t.b, 1.5);
verifyEqual(test_case, t.P, [-0.08,0.2], 'AbsTol', 5*eps);
verifyEqual(test_case, t.I.lower, -0.08, 'AbsTol', 5*eps);
verifyEqual(test_case, t.I.upper, 28/75, 'AbsTol', 5*eps);
end

% Division operator
function test_rdivide_tm(test_case)
a = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
b = TaylorModel(1, 2, [8,9,10], Interval(11, 12));
verifyEqual(test_case, rdivide_tm(a, b), a.*reciprocal(b));
end

function test_rdivide_numeric(test_case)
a = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
b = 7;
verifyEqual(test_case, rdivide_numeric(a, b), a.*(1/b));
end

function test_rdivide(test_case)
a = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
b = TaylorModel(1, 2, [8,9,10], Interval(11, 12));
c = 7;
verifyEqual(test_case, a./b, rdivide_tm(a, b));
verifyEqual(test_case, a./c, rdivide_numeric(a, c));
verifyEqual(test_case, c./a, rdivide_tm(c, a));
end

% Power
function test_power(test_case)
a = TaylorModel(1, 2, [3,4,5], Interval(6, 7));
verifyEqual(test_case, a.^1, a);
verifyEqual(test_case, a.^2, a.*a);
verifyEqual(test_case, a.^3, a.*a.*a);
end
