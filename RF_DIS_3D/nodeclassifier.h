#ifndef NODECLASSIFIER_H
#define NODECLASSIFIER_H

#include <vector>
#include "feature.h"
#include "parameters.h"
using namespace std;

// structure for a pyramid region
typedef struct pm_cuboid
{
  float x, y, t, wid, hgt, win;
} PMCUBOID;


inline PMCUBOID PMCuboid(float _x, float _y, float _t, float _wid, float _hgt, float _win)
{
  PMCUBOID pe;
  pe.x = _x;
  pe.y = _y;
  pe.t = _t;
  pe.wid = _wid;
  pe.hgt = _hgt;
  pe.win = _win;
  return pe;
}

/*
float TrainCurrentRegion(float ftrX, float ftrY, float ftrWid, float ftrHgt,
    int &ftrDim, float *ftrWeight, vector<SINGLEIM> imVec, vector<int> trainClassID,
    vector<int> trainID, vector<int> valClassID, vector<int> valID, PARAMETER param, 
    vector<int> &leftTrainID, vector<int> &rightTrainID, vector<int> &leftValID, 
    vector<int> &rightValID, vector<PMREGION> &pmRegions);

void MaxPooling(SINGLEIM im, float *feature, vector<PMREGION> pmRegions, 
    PARAMETER param, char *ground);

void GetPmRegionConfig(float ftrX, float ftrY, float ftrWid,
    float ftrHgt, vector<PMREGION> &pmRegions);
*/
#endif
