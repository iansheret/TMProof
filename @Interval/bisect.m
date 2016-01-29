function [a,b] = bisect(x)

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

m = median(x);
a = Interval(lower(x), m);
b = Interval(m, upper(x));

end
