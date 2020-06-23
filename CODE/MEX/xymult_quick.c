/* File: xymult_quick.c                                            */
/* Does a special multiply & summing from Answers question   */
/* Programmer:  James Tursa                                  */
/* Date: 4-Nov-2019                                          */
/* Compile command:  mex -g xymult_quick.c -lmwblas -largeArrayDims  */
/* Includes ----------------------------------------------------------- */
#include "mex.h"
#include "blas.h"
#if false  /* true = use dotproduct code , false = use BLAS ddot */
    #define  xDOT      dotproduct  /* Hard-coded loop */
#elif defined(__OS2__) || defined(__WINDOWS__) || defined(WIN32) || defined(_WIN32) || defined(WIN64) || defined(_WIN64) || defined(_MSC_VER)
    #define  xDOT      ddot        /* Win dot product name */
#else
    #define  xDOT      ddot_       /* linux dot product name */
#endif
double dotproduct( mwSignedIndex *n, double *x, mwSignedIndex *incx,
                                     double *y, mwSignedIndex *incy)
{
    double result = 0.0;
    mwSignedIndex i;
    
    for( i=0; i<*n; i++ ) {
        result += *x * *y;
        x += *incx;
        y += *incy;
    }
    return result;
}
/* Gateway ------------------------------------------------------------ */
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    double *A, *B, *C, *a, *b, *c;
    mwSignedIndex i, j, n, N, INCX=1, INCY=1;
    if( nrhs != 3 || 
        !mxIsDouble(prhs[0]) || !mxIsDouble(prhs[1]) ||
        mxIsSparse(prhs[0])  || mxIsSparse(prhs[1]) ||
        mxIsComplex(prhs[0]) || mxIsComplex(prhs[1]) ||
        mxGetNumberOfDimensions(prhs[0]) != 2 ||
        mxGetNumberOfDimensions(prhs[1]) != 2 ||
        mxGetM(prhs[0]) != mxGetN(prhs[0]) ||
        mxGetM(prhs[1]) != mxGetN(prhs[1]) ||
        mxGetM(prhs[0]) != mxGetM(prhs[1]) ) {
        mexErrMsgTxt("Need exactly two full double square inputs and a scalar");
    }
    if( nlhs > 1 ) {
        mexErrMsgTxt("Too many outputs");
    }
    N = n = mxGetM(prhs[0]);    
    plhs[0] = mxCreateDoubleMatrix(N,N,mxREAL);
    A = (double *) mxGetData(prhs[0]);
    B = (double *) mxGetData(prhs[1]);
    C = (double *) mxGetData(plhs[0]);
    double *nCompute_double = mxGetPr(prhs[2]);
    int nCompute = (int) nCompute_double[0];
    for( i=0; i<nCompute; i++ ) {
        a = A + i * (N+1); /* step A to next diagonal element */
        b = B;             /* start B in upper left corner */
        c = C + i;         /* step C to next row */
        for( j=0; j<n; j++ ) { /* sum(a.*b) is just dot(a_column,b_column) in loop */
            *c = xDOT( &n, a, &INCX, b, &INCY );
            a += N; b += N; c += N; /* move all pointers to next columns */
        }
        n--;
    }
}