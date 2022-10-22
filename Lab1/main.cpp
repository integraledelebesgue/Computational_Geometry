#include<iostream>
#include<array>
#include"det.h"

using namespace std;


int main(void){

    array<array<double, 2>, 2> arr = {{{1.0, 2.0}, {5.0, 9.0}}};

    cout << det(arr) << endl;

    return 0;
}