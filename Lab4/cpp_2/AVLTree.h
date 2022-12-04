#ifndef AVLTREE_H
#define AVLTREE_H
#include "Segment.h"
#include "Node.h"
#include<unordered_map>

class AVLTree{
private:
    Node* root;
    std::unordered_map<Segment, Node*, hash_segment> tree_map;

public:
    AVLTree();
    void insert(const double&, const Segment&);
    void remove(const Segment&);

};


#endif