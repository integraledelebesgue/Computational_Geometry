#ifndef Sweep_h
#define Sweep_h
#include<vector>
#include<array>
#include<queue>
#include "Segment.h"

using namespace std;


vector<array<double, 2>> locate_intersections(vector<array<double, 4>> segments);

void check_for_intersection(priority_queue<double>&, const Segment&, const Segment&);

#endif