classdef TaylorModel
%TAYLORMODEL A minimal taylor model class.
%   This class implements Taylor models, as developed by Berz and Makino.
%   The implementation is based on the detailed description found in Kyoko
%   Makino's PhD thesis, "Rigorous analysis of nonlinear motion in particle
%   accelerators".

% Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
% of the MIT license. See the LICENSE file for details.

    properties (SetAccess = immutable)
        a % Lower bound of range
        b % Upper bound of range
        P % Polynomial model
        I % Remainder interval
    end
    
    methods
        
        % Constructor
        function tm = TaylorModel(a, b, P, I)
            tm.a = a;
            tm.b = b;
            tm.P = P;
            tm.I = I;
            assert(isequal(size(I), [1,1]));
        end
        
        % Derived parameters
        function order = n(tm)
            order = length(tm.P) - 1;
        end
        
        function x = x0(tm)
            x = 0.5*(tm.a + tm.b);
        end
        
        % Fundamental opperators
        % Plus
        function tm = plus(a,b)
            if isnumeric(a)
                tm = plus_tm_numeric(b, a);
            elseif isnumeric(b)
                tm = plus_tm_numeric(a, b);
            else
                tm = plus_tm_tm(a, b);
            end
        end
        
        function tm = plus_tm_numeric(a, b)
            p = a.P;
            p(end) = p(end) + b;
            tm = TaylorModel(a.a, a.b, p, a.I);
        end
        
        function tm = plus_tm_tm(a, b)
            assert(a.a==b.a && a.b==b.b);
            tm = TaylorModel(a.a, a.b, a.P + b.P, a.I + b.I);
        end
        
        % Times
        function tm = times(a,b)
            if isnumeric(a)
                tm = times_tm_numeric(b, a);
            elseif isnumeric(b)
                tm = times_tm_numeric(a, b);
            else
                tm = times_tm_tm(a, b);
            end
        end
        
        function tm = times_tm_tm(a, b)
            assert(a.a==b.a && a.b==b.b);
            n  = a.n;
            x0 = a.x0;
            
            p_all = conv(a.P, b.P);
            [p_high, p_low] = split_polynomial(p_all, n);
            
            ab = Interval(a.a - x0, a.b - x0);
            tm_I =...
                bound_polynomial(p_high, ab) +...
                bound_polynomial(a.P, ab).*b.I +...
                bound_polynomial(b.P, ab).*a.I +...
                a.I.*b.I;
            tm = TaylorModel(a.a, a.b, p_low, tm_I);
        end
        
        function tm = times_tm_numeric(a, b)
            tm = TaylorModel(a.a, a.b, a.P.*b, a.I.*b);
        end
        
        % Derived arithmetic opperators
        function tm = uminus(a)
            tm = -1 .* a;
        end
        
        function tm = minus(a, b)
            tm = a + (-b);
        end
        
        % Inclusion of zero, needed for the reciprocal function.
        function result = includes_zero(a)
            x0 = a.x0;
            ab = Interval(a.a - x0, a.b - x0);
            B = bound_polynomial(a.P, ab) + a.I;
            result =  (B.lower <= 0) && ( 0 <= B.upper);
        end
          
        % Reciprocal
        function tm = reciprocal(a)
            
            % Handle the case where the input includes zero
            if includes_zero(a)
                tm = TaylorModel(a.a, a.b, 0*a.P, Interval(-Inf, Inf));
                return
            end
            
            % Split the constant part (c) from the rest (f_bar).
            [h,c] = split_polynomial(a.P,0);
            f_bar = TaylorModel(a.a, a.b, h, a.I);
            
            % Get the bound (B) on f_bar
            x0 = a.x0;
            ab = Interval(a.a - x0, a.b - x0);
            B = bound_polynomial(f_bar.P, ab) + f_bar.I;
            
            % Evaluate the polynomial part
            tm = 1;
            n = a.n;
            f_bar_i = 1;
            for i=1:n
                f_bar_i = f_bar_i .* f_bar;
                tm = tm + ((-1/c).^i).*f_bar_i;
            end
            tm = tm.*(1/c);
            
            % Evaluate the remainder part
            theta = Interval(0,1);
            r = ((-1).^(n+1)).*B.^(n+1)./(c.^(n+2))./...
                ((1 + theta.*B./c).^(n+2));
            tm = TaylorModel(tm.a, tm.b, tm.P, tm.I + r);
            
        end

        % Division
        function tm = rdivide_tm(a, b)
            tm = a.*reciprocal(b);
        end
        
        function tm = rdivide_numeric(a, b)
            tm = a.*(1/b);
        end
                
        function tm = rdivide(a, b)
            if isnumeric(b)
                tm = rdivide_numeric(a, b);
            else
                tm = rdivide_tm(a, b);
            end
        end
        
        % Power
        function tm = power(a, b)
            assert(isnumeric(b));
            assert(mod(b, 1) == 0);
            assert(b > 0);
            if b==1
                tm = a;
            else
                tm = a .* a.^(b-1);
            end
        end
        
        % Sine
        function tm = sin(a)
            
            % Split the constant part (c) from the rest (f_bar).
            [h,c] = split_polynomial(a.P,0);
            f_bar = TaylorModel(a.a, a.b, h, a.I);
            
            % Get the bound (B) on f_bar
            x0 = a.x0;
            ab = Interval(a.a - x0, a.b - x0);
            B = bound_polynomial(f_bar.P, ab) + f_bar.I;
            
            % Evaluate the polynomial part
            n = a.n;
            g = [cos(c), -sin(c), -cos(c), sin(c)];
            tm = sin(c);
            f_bar_i = 1;
            for i=1:n
                f_bar_i = f_bar_i .* f_bar;
                s = g(mod(i-1,4)+1);
                tm = tm + s.*f_bar_i./factorial(i);
            end
            
            % Evaluate the remainder part
            theta = Interval(0,1);
            d = c + theta.*B;
            g = [cos(d), -sin(d), -cos(d), sin(d)];
            s = g(mod(n,4)+1);
            r = s.*(B.^(n+1))./factorial(n+1);
            tm = TaylorModel(tm.a, tm.b, tm.P, tm.I + r);
            
        end
      
    end
    
end