#include <iostream>
#include <fstream>
#include <cstring>
#include <sys/time.h>

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
            x--;
        }
    }
    if(bitPos != 0)
    {
        arr[arrPos] = pomValue;
    }
}

void findPairs(unsigned int *arr, int64_t n, int l)
{
    int diff, pom;
    for(long comparator = 0; comparator < n - 1; comparator++)
    {
        for(long x = comparator + 1; x < n; x++)
        {
            diff = 0;
            for(int y = 0; y < l; y++)
            {
                pom = (arr[comparator * l + y]^arr[x * l + y]);
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

double GetElapsed(struct timeval begin, struct timeval end)
{
    long seconds = end.tv_sec - begin.tv_sec;
    long microseconds = end.tv_usec - begin.tv_usec;
    return (seconds + microseconds*1e-6) * 1000;
}

int32_t main(int argc, char** argv)
{
    if(argc < 3) return -1;
    std::ifstream data(argv[1]);
    std::ofstream measures(argv[2], std::ios::app);
    struct timeval begin, end;
    int n;
    int l;
    data >> n;
    data >> l;
    int bitsPerInt =  sizeof(unsigned int) * 8 - 1;
    int taken = l / bitsPerInt;
    if(l % bitsPerInt != 0)
        taken++;
    unsigned int* arr = new unsigned int[n * taken];
    memset(arr,0,taken * n * sizeof(unsigned int));
    std::string number;
    int arrPos = 0;
    gettimeofday(&begin, 0);
    while(data >> number)
    {
        parseNumber(&arr[arrPos * taken], number, bitsPerInt);
        arrPos++;
    }
    gettimeofday(&end, 0);
    measures <<"CPU read data: " << GetElapsed(begin,end) << "ms " << std::endl;
    
    gettimeofday(&begin, 0);
    findPairs(arr,n,taken);
    gettimeofday(&end, 0);
    measures <<"CPU algorithm: " << GetElapsed(begin,end) << "ms " << std::endl;
    data.close();
    measures.close();
    delete[] arr;
}