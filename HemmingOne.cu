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
    std::ifstream data(argv[0], ios::out);
    int n;
    int l;
    data >> n;
    data >> l;
    unsigned int** arr = new unsigned int[n][l];
    std::string number;
    int arrPos = 0;
    while(data >> number)
    {
        parseNumber(arr[arrPos], number);
        arrPos++;
    }


    ifstream.close();
    for(int x = 0; x < n; x++)
    {
        delete[] arr[x];
    }
    delete[] arr;
}