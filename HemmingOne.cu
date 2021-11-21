#include <iostream>
#include <fstream>

void parseNumber(unsigned int *arr, std::string number)
{
    int bitNum = sizeof(unsigned int) * 8;
    int bitPos = 0;
    int arrPos = 0;
    unsigned int pomValue = 0;
    for(int x = 0; x < number.length();x++)
    {
        if(bitNum > bitPos)
        {
            pomValue+= (number[x] - '0')<<bitPos;
            bitPos++;
        }
        else
        {
            arr[arrPos] = pomValue;
            arrPos++;
            bitPos = 0;
        }
    }
}

int main(int argc, char** argv)
{
    std::ifstream data(argv[1]);
    int n;
    int l;
    data >> n;
    data >> l;
    unsigned int** arr = new unsigned int*[n];
    for(int x = 0 ; x < n; x++)
    {
        arr[x] = new unsigned int[l];
    }
    std::string number;
    int arrPos = 0;
    while(data >> number)
    {
        parseNumber(arr[arrPos], number);
        arrPos++;
    }
    int taken = l / (sizeof(unsigned int) * 8);
    for(int x =0 ; x<n; x++)
    {
        for (int y = 0; y < taken; y++)
        {
            std::cout << arr[x][y] << ' ';
        }
        std::cout << std::endl;
    }
    data.close();
    for(int x = 0; x < n; x++)
    {
        delete[] arr[x];
    }
    delete[] arr;
}