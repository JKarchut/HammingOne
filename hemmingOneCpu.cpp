#include <iostream>
#include <fstream>

void parseNumber(unsigned int *arr, std::string number, int bitsPerInt)
{
    int bitPos = 0;
    int arrPos = 0;
    unsigned int pomValue = 0;
    for(int x = 0; x < number.length();x++)
    {
        if(bitsPerInt > bitPos)
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

void findPairs(unsigned int *arr, int n, int l)
{
    int diff, pom;
    for(int comparator = 0; comparator < n - 1; comparator++)
    {
        for(int x = comparator + 1; x < n; x++)
        {
            diff = 0;
            for(int y = 0; y < l; y++)
            {
                pom = arr[comparator * l + y]^arr[x * l + y];
                if(pom > 0 && (pom & (pom - 1)) == 0)
                    diff++;
                else if(pom > 0)
                    diff = 2;
                if(diff > 1)
                    break;
            }
            if(diff == 1)
            {
                std::cout<<comparator<<' '<<x<<std::endl;
            }
        }
    }
}

int32_t main(int argc, char** argv)
{
    std::ifstream data(argv[1]);
    int n;
    int l;
    data >> n;
    data >> l;
    int bitsPerInt =  sizeof(unsigned int) * 8;
    int taken = l / bitsPerInt;
    if(l % bitsPerInt != 0)
        taken++;
    unsigned int* arr = new unsigned int[n * taken];
    std::string number;
    int arrPos = 0;
    while(data >> number)
    {
        parseNumber(&arr[arrPos * taken], number, bitsPerInt);
        arrPos++;
    }
    findPairs(arr,n,taken);
    std::cout<<"found";
    data.close();
    delete[] arr;
}