
% Compile MEX file
mex -g xymult_quick.c -lmwblas -largeArrayDims 

% Compute MEX result and M-file result
X = [1 2 3; 4 5 6; 7 8 9];
Y = [10 11 12; 13 14 15; 16 17 18];    
n = size(X,1);
MEX_result = xymult_quick(X,Y,n);
MAT_result = xymult_slow(X,Y,n);

% Test whether MEX result and M-file result are identical
isequal(MEX_result,MAT_result)
