function tests = test_Interval
%TEST_INTERVAL Unit tests for the Interval class.

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

tests = functiontests(localfunctions);

end

% For each opperator, there's a lot of test cases to cover. The easiest way
% to do this is to define a table of inputs and expected outputs, so
% provide a function to implement that.
%
% Each row of the table is a seperate test case. The first two columns are
% the lower and upper limit of the first operand, the next two columns are
% lower and upper limit of the second operand, last two columns are the
% expected result.
function VerifyTruthTable(table, op, testCase)
for i=1:size(table,1)
    a = Interval(table(i,1), table(i,2));
    b = Interval(table(i,3), table(i,4));
    in = op(a, b);
    verifyEqual(testCase, in.lower, table(i,5));
    verifyEqual(testCase, in.upper, table(i,6));
end
end

% Constructor
function TestConstructorGeneratesValidObject(testCase)
in = Interval(3, 7);
verifyEqual(testCase, in.lower, 3);
verifyEqual(testCase, in.upper, 7);
end

% Arithmetic opperators
function TestPlusGivesCorrectAnswer(testCase)
a = 1;
b = 1 + eps;
c = 1 + 2*eps;
p = 2;
q = 2 + 2*eps;
r = 2 + 4*eps;
table = [...
     2,5,    3,7,     5,12;...% No rounding
     a,a,    b,b,     p,q;... % Default rounding is below truth
     b,b,    c,c,     q,r];   % Default rounding is above true value
VerifyTruthTable(table, @plus, testCase);
end

function TestMinusGivesCorrectAnswer(testCase)
a = 1;
b = 1 + eps;
c = 1 + 2*eps;
p = 2;
q = 2 + 2*eps;
r = 2 + 4*eps;
table = [...
     2,5,    3,7,     -5,2;... % No rounding
     a,a,   -b,-b,     p,q;... % Default rounding is below truth
     b,b,   -c,-c,     q,r];   % Default rounding is above true value
VerifyTruthTable(table, @minus, testCase);
end

function TestTimesGivesCorrectAnswer(testCase)
a = 1 + 2^-26;
b = 1 + 2^-27;
p = 1 + 2^-26 + 2^-27;
q = 1 + 2^-26 + 2^-27 + eps;
table = [...
     2,5,    3, 7,    6,35;... % No rounding
    -2,5,    3, 7,  -14,35;... % No rounding
    -2,5,   -7, 3,  -35,15;... % No rounding
     a,a,    b, b,     p,q];   % Default rounding is above true value
VerifyTruthTable(table, @times, testCase);
end

function TestDivideGivesCorrectAnswerForNonNaNCases(testCase)
table = [...
     2,5,    3, 7,    2/7,5/3;...
     2,5,    0, 7,    2/7,Inf;...
     2,5,   -3, 0,   -Inf,Inf;...
     2,2,    7, 7,    2/7,2/7 + eps(2/7);...
     5,5,    3, 3,    5/3-eps(5/3),5/3];
VerifyTruthTable(table, @rdivide, testCase);
end

function TestDivideGivesCorrectAnswerWhenNaN(testCase)
a = Interval(-3, 4);
b = Interval(-2, 5);
in = a ./ b;
import matlab.unittest.constraints.HasNaN;
verifyThat(testCase, in.upper, HasNaN);
verifyThat(testCase, in.lower, HasNaN);
end

function TestPowerGivesCorrectAnswer(testCase)
a = sqrt(7)*pi;
b = sqrt(13)*pi;
aa = Interval(a,a).*Interval(a,a);
bb = Interval(b,b).*Interval(b,b);
aaa = aa.*Interval(a,a);
bbb = bb.*Interval(b,b);
table = [...
      2,5,    0,    1,1;...
      2,5,    1,    2,5;...
      2,5,    2,    4,25;...
     -2,5,    2,    0,25;...
     -2,5,    3,   -8,125;...
      a,b,    2,    aa.lower, bb.upper;...
      a,b,    3,    aaa.lower, bbb.upper;...
     -a,b,    2,    0, bb.upper;...
     -b,a,    2,    0, bb.upper;...
     -a,b,    3,   -aaa.upper, bbb.upper;...
     -b,-a,   2,    aa.lower, bb.upper;...
     -b,-a,   3,   -bbb.upper,-aaa.lower;...
     ];
for i=1:size(table,1)
    a = Interval(table(i,1), table(i,2));
    b = table(i,3);
    in = a .^ b;
    verifyEqual(testCase, in.lower, table(i,4));
    verifyEqual(testCase, in.upper, table(i,5));
end
end

function TestSinGivesCorrectAnswer(testCase)
table = [...
      0.1,0.2,    sin(0.1),sin(0.2);...
      1.7,1.8,    sin(1.8),sin(1.7);...
      1.5,1.6,    sin(1.5),1;...
      4.7,4.8,    -1,sin(4.8);...
      1.5,4.8,    -1,1];
  
for i=1:size(table,1)
    a = Interval(table(i,1), table(i,2));
    in = sin(a);
    verifyEqual(testCase, in.lower, table(i,3));
    verifyEqual(testCase, in.upper, table(i,4));
end
end

function TestCosGivesCorrectAnswer(testCase)
table = [...
      0.1,0.2,    cos(0.2),cos(0.1);...
      3.2,3.3,    cos(3.2),cos(3.3);...
     -0.1,0.2,    cos(0.2),1;...
      3.0,3.5,    -1,cos(3.5);...
     -0.1,3.5,    -1,1];
  
for i=1:size(table,1)
    a = Interval(table(i,1), table(i,2));
    in = cos(a);
    verifyEqual(testCase, in.lower, table(i,3), 'AbsTol', 2*eps);
    verifyEqual(testCase, in.upper, table(i,4), 'AbsTol', 2*eps);
end
end

function TestMedianGivesCorrectAnswer(testCase)
x = Interval(1,2);
verifyEqual(testCase, median(x), 1.5);
end

function TestWidthGivesCorrectAnswer(testCase)
x = Interval(13,17);
verifyEqual(testCase, width(x), 4);
end

function TestBisectGivesCorrectAnswer(testCase)
[a,b] = Interval(13,17).bisect;
verifyEqual(testCase, a.lower, 13);
verifyEqual(testCase, a.upper, 15);
verifyEqual(testCase, b.lower, 15);
verifyEqual(testCase, b.upper, 17);
end

function TestIncludesGivesCorrectAnswer(testCase)
a = Interval(pi,5);
verifyEqual(testCase, a.includes(3), false);
verifyEqual(testCase, a.includes(pi), true);
verifyEqual(testCase, a.includes(4), true);
verifyEqual(testCase, a.includes(5), true);
verifyEqual(testCase, a.includes(5.5), false);
end
