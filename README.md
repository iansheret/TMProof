# AutoProof

Simple proofs on MATLAB functions, using interval arithmetic and Taylor models.

### What is it?

Autoproof is a simple tool for getting guaranteed performance from numerics code. You can use it to:

* Get accuracy and time bounds on code which uses unsafe algorithms like Newton-Raphson.

* Prove that code can never return Inf or NaN, or more generally can never return values outside specified bounds.

* Automate code generation, with a guarantee that the output meets accuracy and execution speed requirements.
