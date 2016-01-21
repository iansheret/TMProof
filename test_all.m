function test_all
%TEST_ALL Execute unit tests

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

% Set up the path
restoredefaultpath;
addpath(pwd);

% Execute all tests
results = runtests(pwd, 'Recursively', true);

% Parse output
num_tests = length(results);
num_passed = 0;
num_failed = 0;
num_incomplete = 0;
duration = 0;
for i=1:num_tests
    num_passed = num_passed + results(i).Passed;
    num_failed = num_failed + results(i).Failed;
    num_incomplete = num_incomplete + results(i).Incomplete;
    duration = duration + results(i).Duration;
end

% Show result
fprintf('Totals:\n');
fprintf('   %i Passed, %i Failed, %i Incomplete.\n',...
    num_passed, num_failed, num_incomplete);
fprintf('   %f seconds testing time.\n', duration);

end