function [result, counterexample] = prove_in_band(f, x0, x1, y0, y1, order)
%PROVE_IN_BAND Prove a function remains within specified bounds 
%   PROVE_IN_BAND(f, x0, x1, y0, y1, order) uses a Taylor model to prove
%   that the function f remains within specified bounds [y0,y1] , given
%   bounds on the input parameter [x0,x1]. The order parameter specifies
%   the taylor model order. If it is possible to prove that the function
%   stays within the bound, PROVE_IN_BAND returns true; otherwise it
%   returns false.
%
%   [result, counterexample] = PROVE_IN_BAND(f, x0, x1, y0, y1, order) can
%   be used to find out why a proof failed. The output parameter
%   counterexample contains an x such that f(x) falls outside of [y0, y1].
   
% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

% Set up a queue and add the initial interval
q = Queue;
q.push(Interval(x0, x1));

% Handle items in the queue
while q.num_items > 0
    
    % Get an interval from the queue, and bound the function over that
    % interval.
    x = q.pop;
    y = bound_function(f, x, order);
    
    % Check if the test has outright failed
    if (y.upper < y0) || (y.lower > y1)
        result         = false;
        counterexample = median(x);
        return
    end
    
    % Check if the test is inconclusive, and if so bisect and add to the
    % queue.
    if (y.lower < y0) || (y.upper > y1)
        [a,b] = bisect(x);
        q.push(a);
        q.push(b);
    end
    
end

result = true;
counterexample = [];

end


function [a,b] = bisect(x)
m = median(x);
a = Interval(x.lower, m);
b = Interval(m, x.upper);
end
