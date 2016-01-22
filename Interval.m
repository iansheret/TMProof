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
            c = Interval(a.lower + b.lower, a.upper + b.upper);
        end
        
        function c = minus(a, b)
            [a, b] = promoteIfNumeric(a, b);
            c = Interval(a.lower - b.upper, a.upper - b.lower);
        end
        
        function c = uminus(a)
            c = Interval(-a.upper, -a.lower);
        end
        
        function c = times(a, b)
            [a, b] = promoteIfNumeric(a, b);
            v = [...
                a.lower.*b.lower, a.lower.*b.upper,...
                a.upper.*b.lower, a.upper.*b.upper];
            c = Interval(min(v), max(v));   
        end
        
        function c = rdivide(a, b)
            [a, b] = promoteIfNumeric(a, b);
            if includesZero(a) && includesZero(b)
                c = Interval(NaN, NaN); 
            elseif sign(b.lower)==-1 && sign(b.upper)~=-1
                c = Interval(-Inf, Inf);    
            else
                v = [...
                    a.lower/b.lower,...
                    a.lower/b.upper,...
                    a.upper/b.lower,...
                    a.upper/b.upper];
                c = Interval(min(v), max(v)); 
            end
        end
        
        function c = power(a,b)
            assert(isnumeric(b));
            if a.lower < 0
                assert(mod(b,1)==0);
            end
            if b==0
                c = Interval(1,1);
            elseif ((mod(b, 2)==1) || (a.lower>=0))
                c = Interval(a.lower^b, a.upper^b);
            elseif (a.upper >=0)
                c = Interval(0, max([a.lower^b, a.upper^b]));
            else
                c = Interval(a.upper.^b,a.lower^b);
            end
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
        
    end
    
end
