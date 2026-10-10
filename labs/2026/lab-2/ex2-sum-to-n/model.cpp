// Ex2 - Sum of the first N integers
#include <iostream>

int main()
{
    int n = 10;
    int sum = 0;

    for (int i = 1; i <= n; i++) {
        sum += i;
    }

    std::cout << "Sum: " << sum << std::endl;
    return 0;
}
