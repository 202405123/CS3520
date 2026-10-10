// Ex4 - Factorial as a procedure
#include <iostream>

int factorial(int n)
{
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

int main()
{
    int n = 5;
    std::cout << "Factorial: " << factorial(n) << std::endl;
    return 0;
}
