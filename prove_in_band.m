function [result, counterexample] = prove_in_band(f, x0, x1, y0, y1, order)
%PROVE_IN_BAND Prove a function remains within specified bounds 
%   PROVE_IN_BAND(f, x0, x1, y0, y1, order) uses a Taylor model to prove
%   that the function f remains within specified bounds [y0,y1] , given
%   bounds on the input parameter [x0,x1]. The optional order parameter
%   specifies the taylor model order (default order is 8). If it is
%   possible to prove that the function stays within the bound,
%   PROVE_IN_BAND returns true; otherwise it returns false.
%
%   [result, counterexample] = PROVE_IN_BAND(f, x0, x1, y0, y1, order) can
%   be used to find out why a proof failed. The output parameter
%   counterexample will contain either
%   
%   - A value x such that f(x) falls outside of [y0, y1], or
%   - In Interval object x such that f(x) cannot be proven to be a subset
%     of [y0, y1].
   
% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

% Add a default order
if nargin==5
    order = 8;
end

% Do a quick check to detect obvious failures.
band = Interval(y0, y1);
x = look_for_failure_in_range(@(x) band.includes(f(x)), x0, x1);
if ~isempty(x)
    result = false;
    counterexample = x;
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
        return
    end
    
    % Bisection suceeded: store the new intervals
    stack(head+1) = a; head = head + 1;
    stack(head+1) = b; head = head + 1;
    
end

result = true;
counterexample = [];

end
