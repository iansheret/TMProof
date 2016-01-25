function list = get_all_doubles_between(a, b)
%GET_ALL_DOUBLES_BETWEEN Exhaustive list of all double precision numbers

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

if a<0 && b>0
    list = [...
        get_all_doubles_between(a, 0),...
        get_all_doubles_between(eps(0), b)];
elseif a<0
    list = flip(-get_all_doubles_between(-b, -a));
else
    list = a;
    while list(end) < b
        list(end+1) = list(end) + eps(list(end));
    end
end
end
