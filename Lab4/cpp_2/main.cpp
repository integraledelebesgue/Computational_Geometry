#include<iostream>
#include "Point.h"
#include "Segment.h"
#include "Node.h"
#include "AVLTree.h"
#include<array>

using namespace std;

int main(){

    AVLTree tree = AVLTree();

    tree.insert(1.0, array<double, 4>{4.0, 3.0, 2.0, 1.0});
    tree.insert(5.0, array<double, 4>{-4.0, 3.0, 2.0, 1.0});
    tree.insert(0.5, array<double, 4>{-4.0, -3.0, 2.0, 1.0});
    
    return 0;
}