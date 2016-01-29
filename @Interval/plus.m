function c = plus(a, b)

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

[a, b] = promote_if_numeric(a, b);
c = Interval(lower(a) + lower(b), upper(a) + upper(b));

end
