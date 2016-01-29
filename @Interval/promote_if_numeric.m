function [a, b] = promote_if_numeric(a, b)

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

if isnumeric(a)
    a = Interval(a,a);
end
if nargin>1 && isnumeric(b)
    b = Interval(b,b);
end

end
