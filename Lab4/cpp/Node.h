#ifndef Node_h
#define Node_h
#include "Segment.h"


class Node{
public:
    Segment data;

    Node();
    Node(const double&, const Segment&);

    Node* successor();
    Node* predecessor();  

private:
    double key;
    Node* left;
    Node* right;

    int height();   
    int difference();

    friend Node* right_rotation(Node*);
    friend Node* right_left_rotation(Node*);
    friend Node* left_right_rotation(Node*);
    friend Node* left_rotation(Node*);
    friend Node* balance(Node*);
    friend Node* insert(Node*, double, const Segment&);
    friend Node* remove(Node*);
};

Node* right_rotation(Node*);
Node* right_left_rotation(Node*);
Node* left_right_rotation(Node*);
Node* left_rotation(Node*);
Node* balance(Node*);
Node* insert(Node*, double, const Segment&);
Node* remove(Node*);


#endif