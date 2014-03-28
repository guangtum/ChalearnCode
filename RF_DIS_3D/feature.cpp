#include <fstream>
#include "feature.h"
//#include "nodeclassifier.h"
#include "mex.h"
using namespace std;

/*
// adjust the class labels so that if they don't start from 0, make them start from 0
void AdjustLabels(vector<SINGLEIM> &imVec, int &classNum)
{
  int minLabel = imVec[0].classLbl;
  int maxLabel = imVec[0].classLbl;
   int count = 0;
  for (vector<SINGLEIM>::iterator imItr = imVec.begin(); imItr < imVec.end(); imItr++)
  {
    if (minLabel > imItr->classLbl)
      minLabel = imItr->classLbl;
    if (maxLabel < imItr->classLbl)
      maxLabel = imItr->classLbl;
    
     count = count + 1;
    

  
   
  }

  classNum = maxLabel - minLabel + 1;
  mexPrintf("   maxLabel: %d\t", maxLabel); 
  mexPrintf("   minLabel: %d\t", minLabel); 
   mexPrintf("   classNum: %d\t", classNum); 
  if (minLabel == 0)
    return;

  for (vector<SINGLEIM>::iterator imItr = imVec.begin(); imItr < imVec.end(); imItr++)
    imItr->classLbl -= minLabel;
}

*/
// Get Video data from the hard drive: each binary file includes a timestamps of all the video
// Assume that we have 10 timestamps for each video, then we need to read 10 binary files
void GetViBinData(vector<SINGLEVIIM> &viVec, char *filename, PARAMETER params)
{
  int gestNum, viArea;
  ifstream fin(filename, ios::in | ios::binary);
  fin.read((char*)&gestNum, sizeof(int));
  
  //gestNum = 500;
  mexPrintf("\n Gesture Number: %d\n", gestNum); 
  for (int i = 0; i < gestNum; i++)
  {
    SINGLEVIIM vi;
    fin.read((char*)&vi.classLbl, sizeof(int));
	fin.read((char*)&vi.classLbl2, sizeof(int));

    
    mexPrintf("lb %d;", vi.classLbl);
    // read upper body gesture data
    fin.read((char*)&vi.ubWidth, sizeof(int));
    fin.read((char*)&vi.ubHeight, sizeof(int));
    viArea = vi.ubWidth * vi.ubHeight;

    vi.ubStartID = (int*)malloc(sizeof(int) * (viArea + 1));
    fin.read((char*)vi.ubStartID, sizeof(int) * (viArea + 1));

    vi.ubCodeID = (int*)malloc(sizeof(int) * vi.ubStartID[viArea]);
    fin.read((char*)vi.ubCodeID, sizeof(int) * vi.ubStartID[viArea]);
    int *codePTR = vi.ubCodeID;
    int codeNum = vi.ubStartID[viArea];
    for (int j = 0; j < codeNum; j++)
    {
      *codePTR -= 1;
      codePTR++;
    }

    vi.ubValue = (float*)malloc(sizeof(float) * vi.ubStartID[viArea]);
    fin.read((char*)vi.ubValue, sizeof(float) * vi.ubStartID[viArea]);

    // read head region data
    vi.hdWidth = 0;
    vi.hdHeight = 0;
    vi.hdStartID = NULL;
    vi.hdCodeID = NULL;
    vi.hdValue = NULL;
    vi.hdFtrDim = 5 * params.isaCodebookSize;
    vi.hdHist = (float*)malloc(sizeof(float) * vi.hdFtrDim);
    /*
    fin.read((char*)im.bgHist, sizeof(float) * 4 * param.siftCodebookSize);
    float *secLayerStartPTR = im.bgHist;
    float *firLayerPTR = im.bgHist + 4 * param.siftCodebookSize;
    memset(firLayerPTR, 0, sizeof(float) * param.siftCodebookSize);
    float *secLayerPTR;
    for (int j = 0; j < param.siftCodebookSize; j++)
    {
      secLayerPTR = secLayerStartPTR;
      for (int k = 0; k < 4; k++)
      {
          
           if (j == 830 && k == 2)
             mexPrintf("\n    1 by 1 and 2 by 2: %f\n", *secLayerPTR); 
          
          
        if (*secLayerPTR > *firLayerPTR)
          *firLayerPTR = *secLayerPTR;
        secLayerPTR += param.siftCodebookSize;
      }
      firLayerPTR++;
      secLayerStartPTR++;
    }*/

    viVec.push_back(vi);
  }

  fin.close();
}


// release the Video data from the memory
void ReleaseViData(vector<SINGLEVIIM> &viVec)
{
  for (int i = 0; i < viVec.size(); i++)
  {
    free(viVec[i].ubStartID);
    free(viVec[i].ubCodeID);
    free(viVec[i].ubValue);
    free(viVec[i].hdStartID);
    free(viVec[i].hdCodeID);
    free(viVec[i].hdValue);
    if (viVec[i].hdHist != NULL)
      free(viVec[i].hdHist);
  }
  viVec.clear();
}

/*

void GetBgPmRegions(vector<PMREGION> &pmRegions, PARAMETER param)
{
  pmRegions.clear();
  pmRegions.push_back(PMRegion(0.0f, 0.0f, 1.0f, 1.0f));
  if (param.bgPyramidLevel > 1)
  {
    for (int i = 0; i < 2; i++)
    {
      for (int j = 0; j < 2; j++)
        pmRegions.push_back(PMRegion((float)i/2.0f, (float)j/2.0f, 0.5f, 0.5f));
    }
  }
  if (param.bgPyramidLevel > 2)
  {
    for (int i = 0; i < 4; i++)
    {
      for (int j = 0; j < 4; j++)
        pmRegions.push_back(PMRegion((float)i/4.0f, (float)j/4.0f, 0.25f, 0.25f));
    }
  }
  if (param.bgPyramidLevel > 3)
  {
    for (int i = 0; i < 8; i++)
    {
      for (int j = 0; j < 8; j++)
        pmRegions.push_back(PMRegion((float)i/8.0f, (float)j/8.0f, 0.125f, 0.125f));
    }
  }
  if (param.bgPyramidLevel > 4)
    mexErrMsgTxt("Too many background pyramid levels!\n");
}



void BgPrePooling(vector<SINGLEIM> &imVec, PARAMETER param)
{
  vector<PMREGION> pmRegions;
  GetBgPmRegions(pmRegions, param);
  int regionNum = pmRegions.size();
  for (vector<SINGLEIM>::iterator imPTR = imVec.begin(); imPTR < imVec.end(); imPTR++)
  {
    imPTR->bgFtrDim = regionNum * param.siftCodebookSize;
    imPTR->bgHist = (float*)malloc(sizeof(float) * imPTR->bgFtrDim);
    MaxPooling(*imPTR, imPTR->bgHist, pmRegions, param, "bg");
  }
}
*/