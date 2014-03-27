#include "mex.h"
void revord(char *input,int len,char *output)
{
    int i;
    for(i=0;i<len-1;i++)
        *(output+i)=*(input+len-i-2);
}
void mexFunction(int nlhs,mxArray *plhs[],int nrhs,const mxArray *prhs[])
{
   
    char *input_buf,*output_buf;
    int buflen,status;
    
   
    if(nrhs!=1)
        mexErrMsgTxt("需要输入一个参数！");
    else if(nrhs>1)
        mexErrMsgTxt("你输入了太多的参数！");
    
   
    if(mxIsChar(prhs[0])!=1)
        mexErrMsgTxt("你输入的不是一个string类型的字符串！");
    
   
    if(mxGetM(prhs[0])!=1)
        mexErrMsgTxt("必须输入的一个行向量！");
   
   buflen=(mxGetM(prhs[0])*mxGetN(prhs[0]))+1;
   
  
   input_buf=mxCalloc(buflen,sizeof(char));
   output_buf=mxCalloc(buflen,sizeof(char));
  
   status=mxGetString(prhs[0],input_buf,buflen);
   if(status!=0)
       mexWarnMsgTxt("没有足够的空间了！");
  
   revord(input_buf,buflen,output_buf);
   
  
   plhs[0]=mxCreateString(output_buf);
   return ;
}