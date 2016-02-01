classdef Interval
%INTERVAL A minimal interval arithmatic class.

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.
    
    properties (SetAccess = immutable)
        lower
        upper
    end
    
    methods
        
        % Constructor
        function obj = Interval(a, b)
            assert(isequal(size(a), [1,1]));
            assert(isequal(size(b), [1,1]));
            obj.lower = a;
            obj.upper = b;
        end
        
        % Promotion
        function [a, b] = promoteIfNumeric(a, b)
            if isnumeric(a)
                a = Interval(a,a);
            end
            if nargin>1 && isnumeric(b)
                b = Interval(b,b);
            end
        end
        
        % Arithmetic opperators
        function c = plus(a, b)
            [a, b] = promoteIfNumeric(a, b);
            system_dependent('setround', -Inf);
            c = Interval(a.lower + b.lower, -(-a.upper - b.upper));
            system_dependent('setround', 0.5);
        end
        
        function c = minus(a, b)
            c = a + (-b);
        end
        
        function c = uminus(a)
            c = Interval(-a.upper, -a.lower);
        end
        
        function c = times(a, b)
            [a, b] = promoteIfNumeric(a, b);
            system_dependent('setround', -Inf);
            v = [...
                a.lower.*b.lower, a.lower.*b.upper,...
                a.upper.*b.lower, a.upper.*b.upper,...
                -((-a.lower).*b.lower), -((-a.lower).*b.upper),...
                -((-a.upper).*b.lower), -((-a.upper).*b.upper)];
            system_dependent('setround', 0.5);
            c = Interval(min(v), max(v));   
        end
        
        function c = rdivide(a, b)
            [a, b] = promoteIfNumeric(a, b);
            if includesZero(a) && includesZero(b)
                c = Interval(NaN, NaN); 
            elseif sign(b.lower)==-1 && sign(b.upper)~=-1
                c = Interval(-Inf, Inf);    
            else
                system_dependent('setround', -Inf);
                v = [...
                    a.lower/b.lower,...
                    a.lower/b.upper,...
                    a.upper/b.lower,...
                    a.upper/b.upper,...
                    -((-a.lower)/b.lower),...
                    -((-a.lower)/b.upper),...
                    -((-a.upper)/b.lower),...
                    -((-a.upper)/b.upper)];
                system_dependent('setround', 0.5);
                c = Interval(min(v), max(v)); 
            end
        end
        
        function c = power_inf(a, b)
            c = Interval(a,a);
            for i=1:b-1
                c = c.*a;
            end
            c = c.lower;
        end
        
        function c = power_sup(a, b)
            c = Interval(a,a);
            for i=1:b-1
                c = c.*a;
            end
            c = c.upper;
        end
        
        function c = power(a,b)
            assert(isnumeric(b));
            assert(mod(b,1)==0);
            assert(b>=0);
            
            % Handle trivial cases
            if b==0
                c = Interval(1,1);
                return
            end
            if b==1
                c = a;
                return;
            end
            
            % For even powers of an interval that includes zero, transform
            % into an equivlent monotonic form
            b_is_even = mod(b,2)==0;
            if (b_is_even && a.includes(0))
                a = Interval(0, max(-a.lower, a.upper));
            end
            
            % Get the bounds
            l = Interval(a.lower, a.lower);
            u = Interval(a.upper, a.upper);
            for i=2:b
                l = l.*a.lower;
                u = u.*a.upper;
            end
            c = Interval(l.lower, u.upper);
        end
        
        % Inclusion of zero, needed for the division opperator.
        function result = includesZero(a)
            u = sign(a.upper);
            l = sign(a.lower);
            if (u==-1 && l==-1) || (u==1 && l==1)
                result = false;
            else
                result = true;
            end
        end
        
        % Sine
        function c = sin(a)
            v = [a.lower, a.upper];
            y = sin(v);
            
            n = floor((a.lower - pi/2)/(2*pi));
            m = floor((a.upper - pi/2)/(2*pi));
            if n~=m
                y = [y, 1];
            end

            n = floor((a.lower - 3*pi/2)/(2*pi));
            m = floor((a.upper - 3*pi/2)/(2*pi));
            if n~=m
                y = [y, -1];
            end

            c = Interval(min(y), max(y));
        end
        
        % Cosine
        function c = cos(a)
            c = sin(a + pi/2);
        end
        
        % Median
        function m = median(a)
            m = 0.5*(a.lower + a.upper);
        end
        
         % Width
        function m = width(a)
            m = a.upper - a.lower; 
        end
        
        % Bisect
        function [a,b] = bisect(x)
            m = median(x);
            a = Interval(x.lower, m);
            b = Interval(m, x.upper);
        end
        
        % Includes
        function result = includes(a, x)
            result = (a.lower<=x) && x<=a.upper;
        end
        
    end
    
end
