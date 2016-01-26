# TMProof

### What is it?

TMProof is a simple tool for getting guaranteed performance from MATLAB numerics code. You can use it to:

* Prove that code can never return Inf or NaN, or more generally can never return values outside specified bounds.

* Get accuracy and time bounds on code which uses unsafe algorithms like Newton-Raphson.

* Automate code generation, with a guarantee that the output meets accuracy and execution speed requirements.

Under the hood, TMProof uses [Taylor Models](http://magix.lix.polytechnique.fr/magix/magixalix/slides/magix_berz_makino.pdf) to guarantee rigorous proofs.

### Quick tour
Lets warm up by proving something obvious. Start by defining a simple function:

```matlab
function y = example_function(x);
    y = sin(x) + (x.^3)./40;
end
```

Plot this so we get an idea what it looks like:

```
>> x = linspace(0, 5, 100);
>> plot(x, example_function(x));
```

![example_function](Images/example_function.png)

To check the bounds on this function, we can use `prove_bounds`

```
>> x_range = [0, 5];
>> y_bounds = [0, 2.5];
>> prove_bounds(@example_function, x_range, y_bounds, 'verbose', true);
Proof succeeded.
```

So far so good. What happens if we ask for a proof on something that isn't true?

```
>> y_bounds = [0, 2.0];
>> prove_bounds(@example_function, x_range, y_bounds, 'verbose', true);
Proof failed: counterexample found at x = 4.924925e+00.
f(x) = 2.008838e+00, which is outside the specified bounds.
```
