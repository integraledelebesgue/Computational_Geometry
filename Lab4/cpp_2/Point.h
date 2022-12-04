#ifndef POINT_H
#define POINT_H
#include<utility>


struct Point{
    double x, y;

    Point();
    Point(const double, const double);
};

double slope(const Point&, const Point&);


#endif