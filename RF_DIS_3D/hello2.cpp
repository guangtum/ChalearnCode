# include <time.h>
# include <mex.h>
# include <string>
#include<iostream>
using namespace std;
//using  std::string;
// matlab entry point
void GetData(string filenamein, char *treefilepath)
{
     string treepath;
     string treefullpath;
     treepath = string(treefilepath);
     treefullpath = filenamein+treepath;
     cout<<filenamein.c_str()<<'\n';
     cout<<treefullpath.c_str()<<'\n';

}
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  char *binfilepath;  
  char *binfilename;
  char *treefilepath;
  string filename[20];
  int plen; 
  int tlen;  

  double *timestamps;
  int timest;
  int status;
  mwSize index;  
  // Currently, we do not have any input or output
  if (nrhs != 3)
    mexErrMsgTxt("Wrong number of inputs"); 
  if (nlhs != 0)
    mexErrMsgTxt("Wrong number of outputs");
  timestamps= (double *)mxGetPr(prhs[2]);
  timest = (int)*timestamps;
  /* Check for proper input type */  
  if (!mxIsChar(prhs[0]) || (mxGetM(prhs[0]) != 1 ) )  {  
    mexErrMsgTxt("Input argument must be a string.");  
   }
  plen = mxGetN(prhs[0])*sizeof(mxChar)+1; 
  tlen = mxGetN(prhs[1])*sizeof(mxChar)+1; 

  
  binfilepath=(char *)mxCalloc(plen,sizeof(mxChar));
  binfilename= (char *)mxCalloc(plen+7,sizeof(mxChar));
  treefilepath= (char *)mxCalloc(tlen,sizeof(mxChar));

  /* Copy the string data into buf. */  
  status = mxGetString(prhs[0], binfilepath, plen);    
  status = mxGetString(prhs[1], treefilepath, tlen);    
  mexPrintf("tree path %s.\n",treefilepath);  

  for(index = 1; index <= timest; index++){ 
      sprintf(binfilename, "%s_%d.txt", binfilepath, index);
      filename[index]=(string)binfilename;
      GetData(filename[index],treefilepath);
  }
  mxFree(binfilepath);  
  mxFree(binfilename);
  mxFree(treefilepath);

}