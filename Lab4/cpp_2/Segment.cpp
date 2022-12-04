#include "Point.h"
#include "Segment.h"

Segment::Segment(){
    start = Point();
    end = Point();
    slope = 0.0;
    intercept = 0.0;
}

Segment::Segment(const Point& start, const Point& end){
    this->start = start;
    this-> end = end;
    slope = (start.y - end.y) / (start.x - end.x);
    intercept = start.y - slope * start.x;
}

Segment::Segment(const Segment& other){
    start = other.start;
    end = other.end;
    slope = other.slope;
    intercept = other.intercept;
}

Segment::Segment(const std::array<double, 4>& arr){
    start = {arr[0], arr[1]};
    end = {arr[2], arr[3]};
}

double key(const Segment& seg, const double& x){
    return seg.slope * x + seg.intercept;
}

size_t Segment::hash_code() const {
    return std::hash<double>{}(slope) + 31 * std::hash<double>{}(intercept);
}

bool Segment::operator ==(const Segment &other)
{
    return slope == other.slope && intercept == other.intercept;
}

Point* intersection(const Segment& seg1, const Segment& seg2){

}

