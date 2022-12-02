#include "Event.h"
#include<cstdarg>

Event::Event(){
    type = none;
    x = 0.0;
    segment_start = nullptr;
    segment_end = nullptr;
    segment_cross_first = nullptr;
    segment_cross_second = nullptr;
}

Event::Event(const Type& type, const Segment& seg1, const Segment &seg2){
    this->type = type;
    segment_start = nullptr;
    segment_end = nullptr;
    segment_cross_first = nullptr;
    segment_cross_second = nullptr;

    switch(type){
        case start:
            x = seg1.start.x;
            segment_start = &(Segment)seg1;
            break;
        
        case end:
            x = seg1.end.x;
            segment_end = &(Segment)seg1;
            break;

        case cross:
            x = intersection(seg1, seg2)->x;
            segment_cross_first = &(Segment)seg1;
            segment_cross_second = &(Segment)seg2;
            break; 
    }
}

Segment* Event::get_data(){
    switch(type){
        case start:
            return segment_start;
        
        case end:
            return segment_end;

        case cross:
            /*Segment* segment_pair = (Segment*)malloc(2 * sizeof(Segment));
            segment_pair[0] = *segment_cross_first;
            segment_pair[1] = *segment_cross_second;
            return segment_pair;*/  // Relatively safe; Use if class field pointer doesn't work properly.
            return segment_cross_first;  // Just add sizeof(Segment) to get segment_cross_second
    }
}

bool operator <(const Event& lhs, const Event& rhs){
    return lhs.x < rhs.x;
}