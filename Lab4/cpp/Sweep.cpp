#include "Sweep.h"
#include "Node.h"
#include "Event.h"
#include <unordered_map>

using namespace std;

vector<array<double, 2>> locate_intersections(vector<array<double, 4>> coordinates){

    // Operational variables:
    const Segment default_segment;
    Segment* curr_segment;
    Node* new_node;
    Node* successor;
    Node* predecessor;
    Event curr;
    // Tree:
    Node* tree = new Node(); // "Segment List"
    unordered_map<Segment, Node*, hash_segment> tree_map;
    // Queue:
    priority_queue<Event> queue;

    for(const Segment& seg : coordinates){
        queue.push(Event(start, seg, default_segment));
        queue.push(Event((Type)2, seg, default_segment));
    }

    while(!queue.empty()){
        curr = (Event)(queue.top());
        queue.pop();

        if(curr.type == start){
            curr_segment = curr.get_data();
            new_node = insert(tree, 0.0, *curr_segment);
            tree_map.insert({*curr_segment, new_node});

            successor = tree_map[*curr_segment]->successor();
            predecessor = tree_map[*curr_segment]->predecessor();

            if(successor) check_for_intersection(queue, *curr_segment, successor->data);
            if(predecessor) check_for_intersection(queue, *curr_segment, predecessor->data);
        }
        else if(curr.type == (Type)2){
            curr_segment = curr.get_data();
            
            successor = tree_map[*curr_segment]->successor();
            predecessor = tree_map[*curr_segment]->predecessor();
            
            if(successor && predecessor) check_for_intersection(queue, predecessor->data, successor->data);

            //tree = tree->remove(tree_map[*curr_segment]);
            tree_map.insert({*curr_segment, nullptr});
        }
        else {

        }
    }
    
}

void check_for_intersection(priority_queue<Event>& queue, const Segment& seg1, const Segment& seg2){
    if(Point* intersec = intersection(seg1, seg2))
        queue.push(Event(cross, seg1, seg2));
}