% This make.m is used under Windows

% add -largeArrayDims on 64-bit machines

mex CFLAGS="\$CFLAGS -std=c99" -O -largeArrayDims -c svm.cpp 
mex CFLAGS="\$CFLAGS -std=c99" -O -largeArrayDims -c svm_model_matlab.c 
mex CFLAGS="\$CFLAGS -std=c99" -O -largeArrayDims svmtrain.c svm.o svm_model_matlab.o
mex CFLAGS="\$CFLAGS -std=c99" -O -largeArrayDims svmpredict.c svm.o svm_model_matlab.o
mex CFLAGS="\$CFLAGS -std=c99" -O -largeArrayDims libsvmread.c
mex CFLAGS="\$CFLAGS -std=c99" -O -largeArrayDims libsvmwrite.c