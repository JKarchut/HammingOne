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
            pomValue += (unsigned int)(number[x] - '0') << bitPos;
            bitPos++;
        }
        else
        {
            arr[arrPos] = pomValue;
            arrPos++;
            bitPos = 0;
            pomValue = 0;
        }
    }
    if(bitPos != 0)
    {
        arr[arrPos] = pomValue;
    }
}

void findPairs(unsigned int **arr, int n, int l)
{
    int diff;
    for(int comparator = 0; comparator < n - 1; comparator++)
    {
        for(int x = comparator + 1; x < n; x++)
        {
            diff = 0;
            for(int y = 0; y < l; y++)
            {
                diff += arr[comparator][y]^arr[x][y];
                if(diff > 1)
                {
                    break;
                }
            }
            if(diff <= 1)
            {
                std::cout<<comparator<<std::endl;
                std::cout<<x<<std::endl;
            }
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
    if(l % (sizeof(unsigned int) * 8) != 0)
        taken++;
    findPairs(arr,n,taken);
    data.close();
    for(int x = 0; x < n; x++)
    {
        delete[] arr[x];
    }
    delete[] arr;
}