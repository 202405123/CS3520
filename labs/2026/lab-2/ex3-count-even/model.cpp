// Ex3 - Count the even elements of an array
#include <iostream>

int count_even(const int arr[], int n)
{
    int count = 0;
    for (int i = 0; i < n; i++) {
        if ((arr[i] & 1) == 0) {
            count++;
        }
    }
    return count;
}

int main()
{
    int array[] = {3, 8, 15, 22, 7, 10, 41, 6};
    int n = 8;

    std::cout << "Even count: " << count_even(array, n) << std::endl;
    return 0;
}
