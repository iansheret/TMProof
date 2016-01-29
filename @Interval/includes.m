function result = includes(a, x)

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

result = (lower(a)<=x) && x<=upper(a);

end
