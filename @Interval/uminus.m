function c = uminus(a)

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

c = Interval(-upper(a), -lower(a));

end
