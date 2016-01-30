// Generic binary operator mex function. The including cpp needs to define
// the op function with the appropreate operator.

// Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
// of the MIT license. See the LICENSE file for details.

#include "mex.h"
#include "boost/numeric/interval.hpp"
#include "mx_interval.hpp"

using I = boost::numeric::interval<double>;

// Declare the operator, but don't define it: that job is left to the
// including class.
I op(const I& a, const I& b);

// Define a gateway function
void mexFunction(
        int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    if(nrhs!=2) {
        mexErrMsgIdAndTxt("Interval:rdivide:nrhs","Two inputs required.");
    }
    if(nlhs>1) {
        mexErrMsgIdAndTxt("Interval:rdivide:nlhs","One output required.");
    }
    
    I a, b;
    try {
        a = interval(prhs[0]);
        b = interval(prhs[1]);
    } catch (std::exception& e) {
        mexErrMsgIdAndTxt("Interval:rdivide:invalid_inputs", e.what());
    }

    auto c = op(a, b);
    plhs[0] = mx_interval(c);
}
