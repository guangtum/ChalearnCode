#include "parameters.h"
#include <string.h>

void SetParameters(PARAMETER &params)
{
  params.treeNum = 100;  // the number of decision trees
  params.maxTreeDepth = 10;  // the maximum tree depth
  params.classNum = 20;  // the number of classes
  params.minExampleNum = 40;  // the minimum number of examples in the node
  params.sampleEmpMethod = 0;  // the method to sample images for the root node;
                              // 0: sample "imageProportion" of the whole images, duplication is not allowed
  params.imageProportion = 0.8;
  params.sampleNumRoot = 300;
  params.sampleNumFirstLayer = 300;
  params.sampleNumRegular = 300;
  
  params.minRegionSize = 0.2;  // the size of the region shouldn't be smaller than <
  params.minTwindowSize = 0.1;  // the size of the time sliding windows shouldn't be smaller than 

  params.isaCodebookSize = 1024;  // the size of the isa codebook
  params.maxEntropy = 0.0f;  // if the entropy value for the current node is this value, 
                         //   we do not need to sample the other features any more
  params.hdPrePooling = 0;  // if we pre-pooling the head information to a 2-layer(0,1,2) spatial pyramid
  params.hdPyramidLevel = 2;  // pyramid levels of head information
  params.leafDistExample = strdup("train");  // based on which set of examples to compute the distribution of leaf node
  params.fineTuning = 1;
}
