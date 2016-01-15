classdef Autodiff
%AUTODIFF A minimal automatic differentiation class.
%   AUTODIFF objects can be used in place of numeric objects (e.g.
%   doubles), and will keep track of the first derivitive of a function.
%   Derivatives are calculated using forward mode automatic
%   differentiation.
%
%   Example:
%   Define a simple function and plot its value and derivitive:
%       f    = @(x) 1./x + x;
%       x    = linspace(0.5, 1.5, 100);
%       x_ad = Autodiff(x);
%       y_ad = f(x_ad);
%       plot(x, [y_ad.x; y_ad.d]);
%       legend('f(x)', 'df(x)/dx')
%
%   See https://en.wikipedia.org/wiki/Automatic_differentiation for a
%   summary of the method, or 'Evaluating Derivatives: Principles and
%   Techniques of Algorithmic Differentiation' by Andreas Griewank for a
%   complete description.

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

    properties (SetAccess = immutable)
        x % The value
        d % The derivitive
    end
    
    methods
        
        % Constructor.
        function ad = Autodiff(x, d)
            ad.x = x;
            if nargin == 1
                ad.d = ones(size(x));
            else
                assert(isequal(size(x), size(d)));
                ad.d = d;
            end
        end
            
        % Fundamental arithmetic opperators
        function ad = plus(a, b)
            if isnumeric(a)
                ad = Autodiff(a + b.x, b.d);
            elseif isnumeric(b)
                ad = Autodiff(a.x + b, a.d);
            else
                ad = Autodiff(a.x + b.x, a.d + b.d);
            end
        end
        
        function ad = times(a, b)
            if isnumeric(a)
                ad = Autodiff(a*b.x, a*b.d);
            elseif isnumeric(b)
                ad = Autodiff(a.x*b, a.d*b);
            else
                ad = Autodiff(a.x.*b.x, a.d.*b.x + a.x.*b.d);
            end
        end
        
        function ad = rdivide(a, b)
            if isnumeric(a)
                ad = Autodiff(a./b.x, -a.*b.d./(b.x.^2));
            elseif isnumeric(b)
                ad = Autodiff(a.x./b, a.d./b);
            else
                ad = Autodiff(a.x./b.x, a.d./b.x - a.x.*b.d./(b.x.^2));
            end
        end
        
        function ad = power(a, b)
            if isnumeric(a)
                ad = Autodiff(a.^b.x, a.^b.x.*log(a).*b.d);
            elseif isnumeric(b)
                ad = Autodiff(a.x.^b, b.*(a.x.^(b-1)).*a.d);
            else
                ad = Autodiff( ...
                    a.x.^b.x, ...
                    a.x.^b.x.*(log(a.x).*b.d+a.d.*b.x./a.x));
            end
        end
        
        % Derived opperators (i.e. ones we can define in terms of the
        % fundamental opperators above).
        function ad = uminus(a)
            ad = -1 .* a;
        end
        
        function ad = minus(a, b)
            ad = a + (-b);
        end
        
        % Transcendental functions
        function ad = log(a)
            ad = Autodiff(log(a.x), a.d./a.x);
        end
        
    end
    
end
