#ifndef PARAMETERS_H
#define PARAMETERS_H

typedef struct _parameter
{
  int timestamps;
  int treeNum;
  int maxTreeDepth;
  int classNum;
  int minExampleNum;
  int sampleEmpMethod;
  float gestureProportion;
  int sampleNumRoot;
  int sampleNumFirstLayer;
  int sampleNumRegular;
  float minRegionSize;
  float minTwindowSize;
  int isaCodebookSize;
  float maxEntropy;
  int hdPrePooling;
  int hdPyramidLevel;
  char *leafDistExample;
  int fineTuning;
} PARAMETER;

void SetParameters(PARAMETER &params);

#endif
