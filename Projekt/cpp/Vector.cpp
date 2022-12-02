#include "Vector.h"
#include<cmath>

using namespace std;


Vector::Vector(){
    x = 0.0;
    y = 0.0;
}

Vector::Vector(const Vector &other){
    x = other.x;
    y = other.y;
}

Vector::Vector(const double x_coord, const double y_coord){
    x = x_coord;
    y = y_coord;
}

Vector::Vector(const array<double, 2> &arr){
    x = arr[0];
    y = arr[1];
}

void Vector::operator +=(const Vector &other){
    x += other.x;
    y += other.y;
}

void Vector::operator *=(const double &scalar){
    x *= scalar;
    y *= scalar;
}

void Vector::operator /=(const double &scalar){
    x /= scalar;
    y /= scalar;
}

Vector::operator std::array<double, 2>(){
    return array<double, 2> {x, y};
}

Vector operator -(const Vector &from, const Vector &what){
    return Vector{from.x - what.x, from.y - what.y};
}

Vector operator *(const double &scalar, const Vector &vec){
    return Vector{vec.x * scalar, vec.y * scalar};
}

Vector operator /(const Vector &vec, const double &scalar){
    return Vector{vec.x / scalar, vec.y / scalar};
}

bool operator ==(const Vector &v1, const Vector &v2){
    return v1.x == v2.x && v1.y == v2.y;
}

Vector sum(const list<Vector> &vectors){
    Vector result;
    for(const Vector &vec : vectors) result += vec;
    return result;
}

double norm(const Vector &vec){
    return sqrt(
        pow(vec.x, 2) + \
        pow(vec.y, 2)
    );
}
