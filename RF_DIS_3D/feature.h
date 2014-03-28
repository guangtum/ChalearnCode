#ifndef FEATURE_H
#define FEATURE_H

#include <iostream>
#include <vector>
#include "parameters.h"
using namespace std;

typedef struct _single_viim
{
  int classLbl, classLbl2;
  int ubWidth, hdWidth;
  int ubHeight, hdHeight;
  int *ubStartID, *hdStartID;
  int *ubCodeID, *hdCodeID;
  float *ubValue, *hdValue;
  int hdFtrDim;  // "hdFtrDim" and "hdHist" is meaning if and only if params.hdPrePool == 1
  float *hdHist;
} SINGLEVIIM;

template <class T>
void CopyVector(vector<T> &dst, vector<T> src)
{
  dst.clear();
  for (int i = 0; i < src.size(); i++)
    dst.push_back(src[i]);
}

void GetViBinData(vector<SINGLEVIIM> &viVec, char *filename, PARAMETER params);
void ReleaseViData(vector<SINGLEVIIM> &viVec);
//void BgPrePooling(vector<SINGLEVIIM> &viVec, PARAMETER param);
void AdjGesLabels(vector<SINGLEVIIM> &viVec, int &classNum);

#endif
