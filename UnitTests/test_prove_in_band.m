function tests = test_prove_in_band
%TEST_PROVE_IN_BAND Unit tests for prove_in_band

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

tests = functiontests(localfunctions);

end

function test_prove_in_band_works_for_true_case(testCase)
f     = @(x) x + 2;
x0    = 0;
x1    = 1; 
y0    = 2;
y1    = 3;
order = 3;
[result,counterexample] = prove_in_band(f, x0, x1, y0, y1, order);
verifyEqual(testCase, result, true);
verifyEqual(testCase, counterexample, []);
end

function test_prove_in_band_works_for_false_case(testCase)
f     = @(x) x + 2;
x0    = 0;
x1    = 1; 
y0    = 2;
y1    = 2.75;
order = 3;
[result,counterexample] = prove_in_band(f, x0, x1, y0, y1, order);
verifyEqual(testCase, result, false);
verifyTrue(testCase, (0.75<=counterexample) && (counterexample<=1));
end

function test_prove_in_band_works_with_deault_order(testCase)
f     = @(x) x + 2;
x0    = 0;
x1    = 1; 
y0    = 2;
y1    = 3;
[result,counterexample] = prove_in_band(f, x0, x1, y0, y1);
verifyEqual(testCase, result, true);
verifyEqual(testCase, counterexample, []);
end

function test_removable_singularity_is_detected(test_case)
f = @(x) x.*(x-2).*(x+2) ./ (x-2);
x0 = 1;
x1 = 5;
y0 = -10;
y1 = 40;
[result,counterexample] = prove_in_band(f, x0, x1, y0, y1);
verifyEqual(test_case, result, false);
verifyEqual(test_case, counterexample, 2);
end

function test_removable_singularity_at_pi_is_detected(test_case)
f = @(x) x.*(x-pi) ./ sin(x);
x0 = 1;
x1 = 5;
y0 = -10;
y1 = 0;
[result,counterexample] = prove_in_band(f, x0, x1, y0, y1);
verifyEqual(test_case, result, false);
verifyTrue(test_case, counterexample.includes(pi));
end
