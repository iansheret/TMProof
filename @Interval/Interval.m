function obj = Interval(a, b)

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

assert(isequal(size(a), [1,1]));
assert(isequal(size(b), [1,1]));
obj.lower = a;
obj.upper = b;

obj = class(obj, 'Interval');

end
