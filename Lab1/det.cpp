#include<array>

using namespace std;

double det(array<array<double, 2>, 2> &arr){
    double result = 0.0;

    __asm__ (
        "lea [array], si;"
    );

    return result;
}