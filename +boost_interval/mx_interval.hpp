// Coversion of boost interval objects to matlab interval objects, and vice
// versa.

// Copyright (c) 2016 Ian Sheret. This project is licensed under the terms
// of the MIT license. See the LICENSE file for details.

#ifndef MX_INTERVAL_HPP
#define MX_INTERVAL_HPP

#include <exception>

#include "mex.h"
#include "boost/numeric/interval.hpp"

using I = boost::numeric::interval<double>;

// Convert a 1x1 real double matrix into a double. This will fail (by
// throwing an exception) if the input isn't valid.
inline double real_double(const mxArray* a)
{
    if (!mxIsDouble(a) || mxIsComplex(a)) {
        throw std::runtime_error("Input not real double");
    }
    
    if (mxGetNumberOfDimensions(a)!=2 || mxGetM(a)!=1 || mxGetN(a)!=1) {
        throw std::runtime_error("Input not scalar");
    }
    
    return *mxGetPr(a);
}

// Convert matlab interval to boost interval. This will fail (by throwing
// an exception) if the input isn't actually a valid matlab interval.
inline I interval(const mxArray* m)
{
    if (!mxIsClass(m, "Interval")){
        throw std::runtime_error("Input isn't an Interval object");
    }
    
    auto lower_field = mxGetProperty(m, 0, "lower");
    auto upper_field = mxGetProperty(m, 0, "upper");
    if (!lower_field || !upper_field) {
        throw std::runtime_error("Input doesn't contain required fields");
    }

    return I(real_double(lower_field), real_double(upper_field));
}

// Convert boost interval to matlab interval
inline mxArray* mx_interval(const I& m)
{
    int nlhs = 1;
    int nrhs = 2;
    mxArray* plhs[1];    
    mxArray* prhs[2];
    prhs[0] = mxCreateDoubleMatrix(1,1,mxREAL);
    prhs[1] = mxCreateDoubleMatrix(1,1,mxREAL);
    double* p_lower  = mxGetPr(prhs[0]);
    double* p_upper  = mxGetPr(prhs[1]);
    *p_lower = m.lower();
    *p_upper = m.upper();

    mexCallMATLAB(nlhs, plhs, nrhs, prhs, "Interval");
    return plhs[0];
}

#endif // #ifndef MX_INTERVAL_HPP
