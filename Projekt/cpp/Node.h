#include<list>
#include "Vector.h"
#include<array>

using namespace std;


class Node {

private:

    list<Vector> points;

    pair<double, double> x_range;       // Pierwsza myśl, można zmienić na wektory/liczby
    pair<double, double> y_range;

    Vector centre;                      // Potrzebne do konstrukcji podziału

    Node *first;                        // Konwencja taka jak w nazewnictwie ćwiartek układu współrzędnych
    Node *second;
    Node *third;
    Node *forth;


public:

    Node();
    Node(list<Vector> &, pair<double, double> &, pair<double, double> &);

    bool isDivisible();                 // Liczba punktów w węźle większa od 1
    bool isLeaf();                      // Każde z dzieci to nullptr

    friend void divideNode(Node &, array<Node *, 4> &);

};


void divideNode(Node &, array<Node *, 4> &);          // Weź węzeł i zapisz dzieci powstałe w podziale do tablicy

// TODO: Haszowanie współrzędnych na numery ćwiartek