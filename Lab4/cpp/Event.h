#ifndef Event_h
#define Event_h
#include<optional>
#include "Point.h"
#include "Segment.h"

typedef enum {none, start, end, cross} Type;

class Event{
public:
    Type type;

    Event();
    Event(const Type&, const Segment&, const Segment&);

    Segment* get_data();

private:
    double x;
    Segment* segment_start; 
    Segment* segment_end; 
    Segment* segment_cross_first;
    Segment* segment_cross_second;

    friend bool operator <(const Event&, const Event&);
};

bool operator <(const Event&, const Event&);

#endif