function c = sin(a)

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

v = [lower(a), upper(a)];
y = sin(v);

n = floor((lower(a) - pi/2)/(2*pi));
m = floor((upper(a) - pi/2)/(2*pi));
if n~=m
    y = [y, 1];
end

n = floor((lower(a) - 3*pi/2)/(2*pi));
m = floor((upper(a) - 3*pi/2)/(2*pi));
if n~=m
    y = [y, -1];
end

c = Interval(min(y), max(y));

end
