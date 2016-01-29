function result = includes_zero(a)

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

u = sign(a.upper);
l = sign(a.lower);
if (u==-1 && l==-1) || (u==1 && l==1)
    result = false;
else
    result = true;
end
end