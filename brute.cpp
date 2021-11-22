#include <iostream>
#include <fstream>
#include <cstring>
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
    for(int comparator = 0; comparator < n ; comparator++)
    {
        for(int x = comparator + 1; x < n; x++)
        {
            diff = 0;
            for(int y = 0; y < l; y++)
            {
                if(arr[x * l + y] != arr[comparator * l + y])
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

int main(int argc, char** argv)
{
    std::ifstream data(argv[1]);
    int n;
    int l;
    data >> n;
    data >> l;
    unsigned int* arr = new unsigned int[n * l];
    memset(arr,0,n * l * sizeof(unsigned int));
    std::string number;
    int arrPos = 0;

    while(data >> number)
    {
        parseNumber(&arr[arrPos * l], number);
        arrPos++;
    }
    findPairs(arr,n,l);
    data.close();
    delete[] arr;
}