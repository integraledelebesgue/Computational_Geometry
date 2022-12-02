#ifndef Segment_h
#define Segment_h
#include<array>
#include "Point.h"

struct hash_segment {
	size_t operator()(const Segment& seg) const
	{
		return seg.hash_code();
	}
};

class Segment{
public:
    Point start;
    Point end;

private:
    double slope;
    double intercept;

public:
    Segment();
    Segment(const Segment&);
    Segment(const Point&, const Point&);
    Segment(const std::array<double, 4>&);

    double hash_code() const;
    
    friend double key(const Segment&, const double&);
    friend Point* intersection(const Segment&, const Segment&);

    bool operator ==(const Segment&);
};

double key(const Segment&, const double&);
Point* intersection(const Segment&, const Segment&);

#endif