// Ex5 - Greatest common divisor by repeated subtraction (Euclid)
#include <iostream>

int gcd(int a, int b)
{
    while (a != b) {
        if (a > b) {
            a -= b;
        } else {
            b -= a;
        }
    }
    return a;
}

int main()
{
    int x = 48;
    int y = 18;
    std::cout << "GCD: " << gcd(x, y) << std::endl;
    return 0;
}
