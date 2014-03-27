# include <time.h>
# include <mex.h>
// matlab entry point
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  char *buf;  
  int buflen;  
  double *timestamps;
  int status;
  (void) plhs;    /* unused parameters */    
  // Currently, we do not have any input or output
  if (nrhs != 2)
    mexErrMsgTxt("Wrong number of inputs"); 
  if (nlhs != 0)
    mexErrMsgTxt("Wrong number of outputs");
  timestamps= (double *)mxGetPr(prhs[1]);
  /* Check for proper input type */  
  if (!mxIsChar(prhs[0]) || (mxGetM(prhs[0]) != 1 ) )  {  
    mexErrMsgTxt("Input argument must be a string.");  
   }
  buflen = mxGetN(prhs[0])*sizeof(mxChar)+1;  
 // buf = mxMalloc(buflen);  
  buf=(char *)mxCalloc(buflen,sizeof(mxChar));
  /* Copy the string data into buf. */   
  status = mxGetString(prhs[0], buf, buflen);    
  //char path4bin;
  //path4bin = mxGetString(prhs[0]);
  //mexPrintf("%s\n",path4bin[0]);
  mexPrintf("path %s, time stamps %f .\n",buf, *timestamps);
  mxFree(buf);  
}