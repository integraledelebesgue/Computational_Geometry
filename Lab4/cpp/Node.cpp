#include "Node.h"
#include "Segment.h"

using namespace std;

Node::Node(){
    data = Segment();
    key = 0.0;
    left = nullptr;
    right = nullptr;
}

Node::Node(const double& key, const Segment& seg){
    data = seg;
    left = nullptr;
    right = nullptr;
    this->key = key;
}

int Node::height(){
    return max(left ? left->height() : 0, right ? right->height() : 0) + 1;
}

int Node::difference(){
    return (left ? left->height() : 0) - (right ? right->height() : 0);  // Convention: left - right
}

Node* right_rotation(Node* parent){
    Node* t = parent->left;
    t->left = nullptr;
    t->right = parent;

    return t;
}

Node* left_rotation(Node* parent){
    Node* t = parent->right;
    parent->right = nullptr;
    t->left = parent;

    return t;
}

Node* right_left_rotation(Node* parent){
    Node* middle = parent->right;
    middle->left->right = middle;
    parent->right = middle->left;
    middle->left = nullptr;

    return left_rotation(parent);
}

Node* left_right_rotation(Node* parent){
    Node* middle = parent->left;
    middle->right->left = middle;
    parent->left = middle->right;
    middle->right = nullptr;

    return right_rotation(parent);
}

Node* balance(Node* parent){
    int balance_factor = parent->difference();
    
    if(balance_factor > 1) {
        if(parent->left->difference() > 0)
            parent = left_rotation(parent);
        else
            parent = left_right_rotation(parent);
    }

    else if(balance_factor < -1) {
        if(parent->right->difference() > 0)
            parent = right_left_rotation(parent);
        else
            parent = right_rotation(parent);
    }

    return parent;
}

Node* insert(Node* root, double key, const Segment& data){
    if(root == nullptr)
        return (root = new Node(key, data));
    else if(key < root->key) {
        root->left = insert(root->left, key, data);
        root = balance(root);
    }
    else {
        root->right = insert(root->right, key, data);
        root = balance(root);
    }
}
