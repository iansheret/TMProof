function c = times(a, b)

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

[a, b] = promote_if_numeric(a, b);
v = [...
    lower(a).*lower(b), lower(a).*upper(b),...
    upper(a).*lower(b), upper(a).*upper(b)];
c = Interval(min(v), max(v));

end
