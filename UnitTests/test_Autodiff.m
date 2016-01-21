function tests = test_Autodiff
%TEST_AUTODIFF Unit tests for the Autodiff class.

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

tests = functiontests(localfunctions);

end

% Constructor
function TestConstructorGeneratesValidObjectWithSingleParameter(testCase)
ad = Autodiff(2);
verifyEqual(testCase, ad.x, 2);
verifyEqual(testCase, ad.d, 1);
end

function TestConstructorGeneratesValidObjectWithTwoParameters(testCase)
ad = Autodiff(2, 7);
verifyEqual(testCase, ad.x, 2);
verifyEqual(testCase, ad.d, 7);
end

% Fundamental arithmetic opperators
function TestPlusGivesCorrectAnswer(testCase)
ad = Autodiff(2,5) + Autodiff(3,7);
verifyEqual(testCase, ad.x, 5);
verifyEqual(testCase, ad.d, 12);
end

function TestTimesGivesCorrectAnswer(testCase)
ad = Autodiff(2,5) .* Autodiff(3,7);
verifyEqual(testCase, ad.x, 6);
verifyEqual(testCase, ad.d,  5*3 + 2*7);
end

function TestDivideGivesCorrectAnswer(testCase)
ad = Autodiff(2,5) ./ Autodiff(3,7);
verifyEqual(testCase, ad.x, 2/3);
verifyEqual(testCase, ad.d, 5/3 - 2*7/(3*3));
end

function TestPowerGivesCorrectAnswer(testCase)
ad = Autodiff(2,5) .^ Autodiff(3,7);
verifyEqual(testCase, ad.x, 8);
verifyEqual(testCase, ad.d, 2^3 * (log(2)*7 + 5*3/2) );
end

% Derived opperators
function TestUnaryMinusGivesCorrectAnswer(testCase)
ad = -Autodiff(2,5);
verifyEqual(testCase, ad.x, -2);
verifyEqual(testCase, ad.d, -5);
end

function TestMinusGivesCorrectAnswer(testCase)
ad = Autodiff(2,5) - Autodiff(3,7);
verifyEqual(testCase, ad.x, -1);
verifyEqual(testCase, ad.d, -2);
end

% Transcendental functions
function TestLogGivesCorrectAnswer(testCase)
ad = log(Autodiff(2,5));
verifyEqual(testCase, ad.x, log(2));
verifyEqual(testCase, ad.d, 5/2);
end
