function tests = test_prove_bounds

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

tests = functiontests(localfunctions);

end

function test_proof_works_for_true_case(testCase)
f     = @(x) x + 2;
x     = [0, 1]; 
y     = [2, 3];
order = 3;
[result,counterexample] = prove_bounds(f, x, y, order);
verifyEqual(testCase, result, true);
verifyEqual(testCase, counterexample, []);
end

function test_proof_works_for_false_case(testCase)
f     = @(x) x + 2;
x     = [0, 1]; 
y     = [2, 2.75];
order = 3;
[result,counterexample] = prove_bounds(f, x, y, order);
verifyEqual(testCase, result, false);
verifyTrue(testCase, (0.75<=counterexample) && (counterexample<=1));
end

function test_proof_works_with_deault_order(testCase)
f = @(x) x + 2;
x = [0, 1]; 
y = [2, 3];
[result,counterexample] = prove_bounds(f, x, y);
verifyEqual(testCase, result, true);
verifyEqual(testCase, counterexample, []);
end

function test_removable_singularity_is_detected(test_case)
f = @(x) x.*(x-2).*(x+2) ./ (x-2);
x = [1, 5];
y = [-10, 40];
[result,counterexample] = prove_bounds(f, x, y);
verifyEqual(test_case, result, false);
verifyEqual(test_case, counterexample, 2);
end

function test_removable_singularity_at_pi_is_detected(test_case)
f = @(x) x.*(x-pi) ./ sin(x);
x = [1, 5];
y = [-10,0];
[result,counterexample] = prove_bounds(f, x, y);
verifyEqual(test_case, result, false);
verifyTrue(test_case, counterexample.includes(pi));
end
