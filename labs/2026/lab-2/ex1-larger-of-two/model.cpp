// Ex1 - Print the larger of two integers
#include <iostream>

int main()
{
    int a = 17;
    int b = 42;
    int larger;

    if (a > b) {
        larger = a;
    } else {
        larger = b;
    }

    std::cout << "Larger: " << larger << std::endl;
    return 0;
}