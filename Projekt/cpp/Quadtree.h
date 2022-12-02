#ifndef Quadtree_h
#define Quadtree_h
#include<list>
#include "Node.h"

using namespace std;


class Quadtree{

private:
    Node *root;
    int depth;

public:
    Quadtree();  // Potencjalnie niepotrzebny, chyba, że chcę mieć las drzew czwórkowych w wektorze XD
    Quadtree(list<Vector> &);
    //list<Vector> pointQuery(pair<double, double> &, pair<double, double> &);

};


#endif

// TODO: Wydzielić osobny plik na funckje zapytań (Potencjalna możliwość trzymania w wysokopoziomowym kodzie adresu drzewa i egzekucji nowych zapytań)