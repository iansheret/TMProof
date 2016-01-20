function TestAll

% Set up the path
restoredefaultpath;
addpath(pwd);

% Execute all tests
results = runtests(pwd, 'Recursively', true);

% Parse output
numTests = length(results);
numPassed = 0;
numFailed = 0;
numIncomplete = 0;
duration = 0;
for i=1:numTests
    numPassed = numPassed + results(i).Passed;
    numFailed = numFailed + results(i).Failed;
    numIncomplete = numIncomplete + results(i).Incomplete;
    duration = duration + results(i).Duration;
end

% Show result
fprintf('Totals:\n');
fprintf('   %i Passed, %i Failed, %i Incomplete.\n', numPassed, numFailed, numIncomplete);
fprintf('   %f seconds testing time.\n', duration);

end