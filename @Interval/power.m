function c = power(a,b)

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

assert(isnumeric(b));
if a.lower < 0
    assert(mod(b,1)==0);
end
if b==0
    c = Interval(1,1);
elseif ((mod(b, 2)==1) || (lower(a)>=0))
    c = Interval(lower(a)^b, upper(a)^b);
elseif (a.upper >=0)
    c = Interval(0, max([lower(a)^b, upper(a)^b]));
else
    c = Interval(upper(a).^b,lower(a)^b);
end

end
