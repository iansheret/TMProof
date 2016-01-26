function [result, counterexample] = prove_bounds(...
    f, x_range, y_bounds, varargin)
%PROVE_BOUNDS Prove a function remains within specified bounds 
%   PROVE_BOUNDS(f, x_range, y_bounds) uses a Taylor model to prove
%   that the function f remains within specified bounds y_bounds = [y0,y1],
%   given bounds on x_range = [x0,x1]. If it is possible to prove that the
%   function stays within the bound, PROVE_BOUNDS returns true; otherwise
%   it returns false.
%
%   PROVE_BOUNDS(f, x_range, y_bounds, order) specifies the order of the
%   taylor model; the default is 8.
%
%   PROVE_BOUNDS(f, x_range, y_bounds, order, 'verbose', true) outputs
%   a message explaining the result.
%
%   [result, counterexample] = PROVE_BOUNDS(f, x_range, y_bounds, order)
%   can be used to find out why a proof failed. The output parameter
%   counterexample will contain either
%   
%   - A value x such that f(x) falls outside of [y0, y1], or
%   - In Interval object x such that f(x) cannot be proven to be a subset
%     of [y0, y1].
   
% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

% Parse inputs
default_order   = 8;
default_verbose = false;
check_f         = @(x) isa(x, 'function_handle');
check_range     = @(x) isnumeric(x) && isequal(size(x), [1, 2]);
check_order     = @(x) isnumeric(x) && mod(x,1)==0 && 1<=x;
p               = inputParser;
addRequired(p,  'f',                        check_f);
addRequired(p,  'x_range',                  check_range);
addRequired(p,  'y_bounds',                 check_range);
addOptional(p,  'order',   default_order,   check_order);
addParameter(p, 'verbose', default_verbose, @islogical);
parse(p, f, x_range, y_bounds, varargin{:});
order   = p.Results.order;
verbose = p.Results.verbose;

% Do a quick check to detect obvious failures.
x0 = x_range(1);
x1 = x_range(2);
y0 = y_bounds(1);
y1 = y_bounds(2);
band = Interval(y0, y1);
x = look_for_failure_in_range(@(x) band.includes(f(x)), x0, x1);
if ~isempty(x)
    result = false;
    counterexample = x;
    emit_message_if_needed(counterexample, f(counterexample), verbose);
    return
end

% Make a simple stack containing the initial interval;
stack = Interval(x0, x1);
head = 1;

% Handle remaining items
while head > 0
    
    % Get the next interval, and bound the function over that interval.
    x    = stack(head); head = head - 1;
    y    = bound_function(f, x, order);
    
    % Check if the test has outright failed
    if (y.upper < y0) || (y.lower > y1)
        result         = false;
        counterexample = median(x);
        emit_message_if_needed(counterexample, f(counterexample), verbose);
        return
    end
    
    % If this iterval has passed, we can move onto the next item without
    % taking any further action
    if (y0 <= y.lower && y.upper <= y1)
        continue
    end
    
    % This interval has failed: attempt to bisect it.
    [a,b] = bisect(x);
    too_small_to_bisect = (isequal(a,x) || isequal(b,x));
    
    % If the bisection failed, try to find an outright counterexample;
    % otherwise return the failing interval.
    if too_small_to_bisect
        result = false;
        c = look_for_failure_nearby(@(p) band.includes(f(p)), x.lower);
        if ~isempty(c)
            counterexample = c;
        else
            counterexample = x;
        end
        emit_message_if_needed(counterexample, f(counterexample), verbose);
        return
    end
    
    % Bisection suceeded: store the new intervals
    stack(head+1) = a; head = head + 1;
    stack(head+1) = b; head = head + 1;
    
end

result = true;
counterexample = [];
emit_message_if_needed(counterexample, [], verbose);

end

function emit_message_if_needed(x, y, verbose)
if ~verbose
    return
elseif isempty(x)
	fprintf('Proof succeeded.\n');
elseif isnumeric(x)
	fprintf('Proof failed: counterexample found at x = %e.\n', x);
    fprintf('f(x) = %e, ', y);
	fprintf('which is outside the specified bounds.\n');
else
    fprintf('Proof failed: unable to prove interval centered at\n');
    fprintf('x = %e ', median(x));
    fprintf('with width %e.\n', width(x));
    fprintf('The best bounds on f(x) is an interval centered on\n');
    fprintf('y = %e ', median(y));
    fprintf('with width %e.\n', width(y));
end
end
