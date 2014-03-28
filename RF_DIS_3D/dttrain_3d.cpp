#include <time.h>
#include <math.h>
#include "feature.h"
#include "parameters.h"
//#include "decisiontree.h"
//#include "treeaccessory.h"
#include "mex.h"

// matlab entry point
void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[]) {
  // Currently, we do not have any input or output
  if (nrhs != 3)
    mexErrMsgTxt("Wrong number of inputs. We need: 1, path of the binary file; 2, path to save the tree.txt; 3, the temporal dimension"); 
  if (nlhs != 0)
    mexErrMsgTxt("Wrong number of outputs");

  // set the seed for random numbers
  srand(time(NULL));
  
  char *binfilepath;  
  char *binfilename;
  char *treefilepath;
  char *treefilename;
  
  int plen; 
  int tlen;  
  
  double *timestamps;
  int timest;
  int status;
  mwSize index;  
  timestamps= (double *)mxGetPr(prhs[2]);
  timest = (int)*timestamps;
  plen = mxGetN(prhs[0])*sizeof(mxChar)+1; 
  tlen = mxGetN(prhs[1])*sizeof(mxChar)+1; 

  
  binfilepath=(char *)mxCalloc(plen,sizeof(mxChar));
  binfilename= (char *)mxCalloc(plen+7,sizeof(mxChar));
  treefilepath= (char *)mxCalloc(tlen,sizeof(mxChar));
  treefilename= (char *)mxCalloc(tlen+100,sizeof(mxChar));
  
  /* Copy the string data into pathname. */  
  status = mxGetString(prhs[0], binfilepath, plen);    
  status = mxGetString(prhs[1], treefilepath, tlen);    

  mexPrintf("Start getting data from the binary files.\n");
    // set parameters for learning
  PARAMETER params;
  SetParameters(params);
  vector<SINGLEVIIM> viVec;
  for(index = 1; index <= timest; index++){ 
      sprintf(binfilename, "%s_%d.txt", binfilepath, index);
      GetViBinData(viVec, binfilename, params);
      mexPrintf("Reading the binary file...%s\n",binfilename);
  }
  mexPrintf("Finish getting data from the binary files.\n");
/*
  // set parameters for learning
  PARAMETER param;
  SetParameters(param);

  // get image feature descriptors from the file
  vector<SINGLEIM> imVec;
  int classNum;
  
   GetData(imVec, "trainval_0.txt", param); 
   
  
   GetData(imVec, "trainval_0_flipped.txt", param); 
 
  AdjustLabels(imVec, classNum);
  mexPrintf("Finish getting data from the disk.\n");

  // pre-pooling for the background information, if it is necessary
//  if (param.bgPrePooling == 1)
//    BgPrePooling(imVec, param);
//  mexPrintf("Finish getting background feature.\n");

  // the pre-allocated memory for all the trees
  int treeMemSize = int(pow(2, param.maxTreeDepth + 1)) * param.treeNum;
  TREENODE *treeMemory = new TREENODE[treeMemSize];
  InitTreeMem(treeMemory, treeMemSize);
  int treeMemID = 0; 
  vector<TREENODE*> trees;  // the set of decision trees
  for (int i = 0; i < param.treeNum; i++)
  {
    trees.push_back(treeMemory + treeMemID);
    treeMemID++;
  }
  mexPrintf("Finish initializing all the trees.\n");

  // train decision trees
  clock_t t1, t2;
  vector<int> trainID, valID;  // indicate which samples are included in the current tree node
  char filename[1024];
  float *valDist = (float*)malloc(sizeof(float) * classNum);  // sample distribution in the val set
  for (int i = 0; i < param.treeNum; i++)
  {
    t1 = clock();
    GetFilename(filename);
    mexPrintf("\nThe current tree will be in this file: %s\n", filename);
    trainID.clear();
    valID.clear();
    InitializeTree(trees[i]);
    int nodeID = 0;
    memset(valDist, 0, sizeof(float) * classNum);
    TrainDecisionTree(trees[i], imVec, param, trainID, valID, 
        classNum, nodeID, treeMemory, treeMemID, valDist);
//    sprintf(filename, "trees/tree_%d%d%d.txt", i / 100, (i % 100) / 10, i % 10);
    OutputTree(trees[i], filename);
    t2 = clock();
    mexPrintf("\n    Time for trainning this tree: %f\n", (float)(t2 - t1) / CLOCKS_PER_SEC);
  }

  free(valDist);
 */
  ReleaseViData(viVec);
  /*
  for (int i = 0; i < param.treeNum; i++)
    ReleaseTreeMem(trees[i]);
  delete[] treeMemory;
  */
 
}
