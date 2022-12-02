#include "AVLTree.h"

using namespace std;

AVLTree::AVLTree(){
    root = nullptr;
    tree_map = unordered_map<Segment, Node*, hash_segment>();
}

void AVLTree::insert(const double& key, const Segment& seg){
    Node* new_node = new Node(key, seg);
    tree_map.insert({seg, new_node});
    insert_node(root, new_node);
}