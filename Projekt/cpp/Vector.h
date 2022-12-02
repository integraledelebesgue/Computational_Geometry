#ifndef Vector_h
#define Vector_h

#include<array>
#include<list>;

using namespace std;


class Vector{       // Może potrzebny, może nie. Skopiowany z innego projektu w czasie stałym.

private:

    double x, y;


public:

    Vector();
    Vector(const Vector &);
    Vector(double , double);
    Vector(const array<double, 2> &);

    void operator +=(const Vector &);
    void operator *=(const double &scalar);
    void operator /=(const double &scalar);

    operator array<double, 2>();

    friend double norm(const Vector &vec);
    friend Vector operator -(const Vector &, const Vector &);
    friend Vector operator *(const double &, const Vector &);
    friend Vector operator /(const Vector &vec, const double &scalar);
    friend bool operator ==(const Vector &, const Vector &);
    friend Vector sum(const list<Vector> &);
    
};


double norm(const Vector &vec);
Vector operator -(const Vector &, const Vector &);
Vector operator *(const double &, const Vector &);
Vector operator /(const Vector &vec, const double &scalar);
bool operator ==(const Vector &, const Vector &);
Vector sum(const list<Vector> &);


#endif 