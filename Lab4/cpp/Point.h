#ifndef Point_h
#define Point_h
#include<utility>


struct Point{
    double x, y;

    Point();
    Point(const double, const double);
};

double slope(const Point&, const Point&);


#endif