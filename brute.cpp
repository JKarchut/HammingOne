#include <iostream>
#include <fstream>

void parseNumber(unsigned int *arr, std::string number)
{
    for(int x = 0; x < number.length();x++)
    {
        arr[x] = (number[x] - '0');
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
                if(arr[comparator * l + y] != arr[x * l + y])
                    diff++;
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
    int bitsPerInt =  sizeof(unsigned int) * 8 - 1;
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
    data.close();
    delete[] arr;
}